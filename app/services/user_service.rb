require 'net/http'
require 'json'

class UserService
  def self.consume_api
    uri = URI(UserConstants::API_URL)
    response = Net::HTTP.get_response(uri)

    unless response.is_a?(Net::HTTPSuccess)
      raise "Erro na requisição: #{response.code}"
    end

    JSON.parse(response.body)
  rescue StandardError => e
    raise e.message.to_s
  end
end
