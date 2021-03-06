# frozen_string_literal: true

require 'rails_helper'
require 'support/api_session_helpers'
require 'support/shared_api_response_behaviors'

RSpec.describe Goggles::UsersAPI, type: :request do
  include GrapeRouteHelpers::NamedRouteMatcher
  include APISessionHelpers

  let(:api_user)     { FactoryBot.create(:user) }
  let(:jwt_token)    { jwt_for_api_session(api_user) }
  let(:fixture_row) { FactoryBot.create(:user) }
  let(:fixture_headers) { { 'Authorization' => "Bearer #{jwt_token}" } }

  # Enforce domain context creation
  before(:each) do
    expect(fixture_row).to be_a(GogglesDb::User).and be_valid
    expect(api_user).to be_a(GogglesDb::User).and be_valid
    expect(jwt_token).to be_a(String).and be_present
  end

  describe 'GET /api/v3/user/:id' do
    context 'when using valid parameters,' do
      before(:each) { get(api_v3_user_path(id: fixture_row.id), headers: fixture_headers) }
      it_behaves_like('a successful JSON row response')
    end

    context 'when using an invalid JWT,' do
      before(:each) { get(api_v3_user_path(id: fixture_row.id), headers: { 'Authorization' => 'you wish!' }) }
      it_behaves_like('a failed auth attempt due to invalid JWT')
    end

    context 'when requesting a non-existing ID,' do
      before(:each) { get(api_v3_user_path(id: -1), headers: fixture_headers) }
      it_behaves_like('an empty but successful JSON response')
    end
  end
  #-- -------------------------------------------------------------------------
  #++

  describe 'PUT /api/v3/user/:id' do
    let(:new_user_values) { FactoryBot.build(:user) }
    let(:new_swimmer) { FactoryBot.create(:swimmer) }
    let(:expected_changes) do
      [
        { name: new_user_values.name },
        { first_name: new_user_values.first_name, last_name: new_user_values.last_name },
        { description: new_user_values.description },
        { year_of_birth: new_user_values.year_of_birth },
        { swimmer_id: new_swimmer.id }
      ].sample
    end
    before(:each) do
      expect(new_swimmer).to be_a(GogglesDb::Swimmer).and be_valid
      expect(new_user_values).to be_a(GogglesDb::User)
      expect(expected_changes).to be_an(Hash).and be_present
    end

    context 'when using valid parameters,' do
      before(:each) { put(api_v3_user_path(id: fixture_row.id), params: expected_changes, headers: fixture_headers) }
      it_behaves_like('a successful JSON PUT response')
    end

    context 'when using an invalid JWT,' do
      before(:each) { put(api_v3_user_path(id: fixture_row.id), params: expected_changes, headers: { 'Authorization' => 'you wish!' }) }
      it_behaves_like('a failed auth attempt due to invalid JWT')
    end

    context 'when requesting a non-existing ID,' do
      before(:each) { put(api_v3_user_path(id: -1), params: expected_changes, headers: fixture_headers) }
      it_behaves_like('an empty but successful JSON response')
    end
  end
  #-- -------------------------------------------------------------------------
  #++

  describe 'GET /api/v3/users/' do
    context 'when using a valid authentication' do
      let(:fixture_first_name) { GogglesDb::User.select(:first_name).limit(100).map(&:first_name).sample }
      let(:fixture_last_name)  { GogglesDb::User.select(:last_name).limit(100).map(&:last_name).sample }
      # Choose among the many existing rows in the seed w/ more than 25 rows per domain => pagination guaranteed)
      let(:fixture_email)    { '@fake.example.' }
      let(:default_per_page) { 25 }

      # Make sure the Domain contains the expected seeds:
      before(:each) do
        expect(fixture_first_name).to be_present
        expect(fixture_email).to be_present
        expect(GogglesDb::User.where('first_name LIKE ?', "%#{fixture_first_name}%").count).to be_positive
        expect(GogglesDb::User.where('email LIKE ?', "%#{fixture_email}%").count).to be_positive.and be > 25
      end

      context 'without any filters,' do
        before(:each) { get(api_v3_users_path, headers: fixture_headers) }
        it_behaves_like('successful response with pagination links & values in headers')
      end

      context 'when filtering by a specific first_name,' do
        before(:each) { get(api_v3_users_path, params: { first_name: fixture_first_name }, headers: fixture_headers) }

        it_behaves_like('a successful request that has positive usage stats')

        it 'returns a JSON array of associated, filtered rows' do
          result_array = JSON.parse(response.body)
          expect(result_array).to be_an(Array)
          full_count = GogglesDb::User.where('first_name LIKE ?', "%#{fixture_first_name}%").count
          expect(result_array.count).to eq(full_count <= default_per_page ? full_count : default_per_page)
        end
        # (We can't really assert pagination links here)
      end

      context 'when filtering by a specific last_name,' do
        before(:each) { get(api_v3_users_path, params: { last_name: fixture_last_name }, headers: fixture_headers) }

        it_behaves_like('a successful request that has positive usage stats')

        it 'returns a JSON array of associated, filtered rows' do
          result_array = JSON.parse(response.body)
          expect(result_array).to be_an(Array)
          full_count = GogglesDb::User.where('last_name LIKE ?', "%#{fixture_last_name}%").count
          expect(result_array.count).to eq(full_count <= default_per_page ? full_count : default_per_page)
        end
        # (We can't really assert pagination links here)
      end

      context 'when filtering by a portion of an email address,' do
        before(:each) { get(api_v3_users_path, params: { email: fixture_email }, headers: fixture_headers) }
        it_behaves_like('successful response with pagination links & values in headers')
      end

      # This will result in a single row without pagination, always:
      context 'when filtering with a specific email address,' do
        before(:each) { get(api_v3_users_path, params: { email: fixture_row.email }, headers: fixture_headers) }

        it 'returns a JSON array containing the single associated row' do
          expect(response.body).to eq([fixture_row].to_json)
        end
        it_behaves_like('successful single response without pagination links in headers')
      end
    end

    context 'when using an invalid JWT,' do
      before(:each) { get(api_v3_users_path, headers: { 'Authorization' => 'you wish!' }) }
      it_behaves_like('a failed auth attempt due to invalid JWT')
    end

    context 'when filtering by a non-existing value,' do
      before(:each) { get(api_v3_users_path, params: { name: 'NOT-A-NAME' }, headers: fixture_headers) }
      it_behaves_like('an empty but successful JSON list response')
    end
  end
  #-- -------------------------------------------------------------------------
  #++
end
