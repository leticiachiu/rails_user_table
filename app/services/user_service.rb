require 'net/http'
require 'json'

class UserService
  def self.consume_api
    uri = URI(UserConstants::API_URL)
    response = Net::HTTP.get_response(uri)

    raise "Erro na requisição: #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  rescue StandardError => e
    raise "Erro de rede: #{e.message}"
  end
end
