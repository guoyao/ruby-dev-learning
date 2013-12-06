class CloundHelper
  def self.get_credentials(services_string)
    credential = nil
    JSON.parse(services_string).each do |key, value|
      value.each do |obj|
        credential ||= obj["credentials"]
      end
    end
    credential
  end
end