class Provider < ApplicationRecord
  def self.query(npi)
    begin
      res = RestClient.get("#{Constants::NpiRegistryUrl}&number=#{npi}", timeout: Constants::RestClientTimeOut)
      json = JSON.parse(res.body)
      return {result: :error, error: json["Errors"].map! {|e| e['description'] }.join(",") } if json["Errors"].present?
      return {result: :error, error: 'Provider not found'} if json['results'] and json['result_count'] == 0
      record = json["results"].first
      return self.formatter(record)
    rescue RestClient::Exceptions::Timeout => e
      return {result: :error, error: "120s timeout error"}
    rescue JSON::ParserError => e
      return {result: :error, error: "API Data parsing error"}
    rescue StandardError => e
      return {result: :error, error: "You have some error in the server"}
    end
  end

  def self.formatter(hash)
    address_formatter = -> (street, city, state, zipcode) {
      "#{street} #{city} #{state}, #{zipcode}"
    }
    taxonomy = hash['taxonomies'].first
    address = hash['addresses'].first
    basic = hash['basic']
    {
      npi: hash['number'].to_s,
      first_name: basic['authorized_official_first_name'] || basic['first_name'],
      last_name: basic['authorized_official_last_name'] || basic['last_name'], 
      enumeration_type: hash['enumeration_type'],
      taxonomy_code: (taxonomy['code'] rescue nil),
      taxonomy_desc: (taxonomy['desc'] rescue nil),
      organization_name: basic['organization_name'],
      address: address_formatter.call(
        address['address_1'], 
        address['city'], 
        address['state'], 
        address['postal_code']
      )
    }
  end
end
