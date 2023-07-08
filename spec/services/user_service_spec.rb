require 'rails_helper'
require 'webmock/rspec'

RSpec.describe UserService, type: :service do
  describe '.consume_api' do
    let(:api_url) { UserConstants::API_URL }

    it 'returns parsed JSON response' do
      stub_request(:get, api_url)
        .to_return(status: 200, body: '{"name": "John Doe", "age": 25, "email": "john@example.com"}')

      user = FactoryBot.build(:user, name: 'John Doe', age: 25,
                                     email: 'john@example.com')

      response = UserService.consume_api

      expect(response['name']).to eq(user.name)
      expect(response['age']).to eq(user.age)
      expect(response['email']).to eq(user.email)
    end

    it 'raises an error for non-successful HTTP response' do
      stub_request(:get, api_url)
        .to_return(status: 500)

      expect do
        UserService.consume_api
      end.to raise_error(RuntimeError,
                         'Erro na requisição: 500')
    end

    it 'raises a network error for network-related exceptions' do
      stub_request(:get, api_url)
        .to_raise(SocketError.new('Failed to open TCP connection'))

      expect do
        UserService.consume_api
      end.to raise_error(RuntimeError,
                         'Failed to open TCP connection')
    end
  end
end
