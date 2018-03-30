require 'ashttp'
require 'uri'
require 'nokogiri'

# This mixin adds the funcationality to mint a handle from the handle service
# and add it to a resource's ead_location field.
module EADLocationGenerator
  def self.included(base)
    base.extend(ClassMethods)
  end

  def public_url
    File.join(AppConfig[:public_proxy_url], uri)
  end

  def handle_pid
    "#{AppConfig[:umd_handle_namespace] || 'archives'}:#{identifier}"
  end

  def mint_handle!
    # rubocop:disable LineLength
    handle_service_uri =
      URI("#{AppConfig[:umd_handle_server_url]}/?action=add&static_url=#{public_url}&pid=#{handle_pid}")
    # rubocop:enable LineLength

    res = ASHTTP.get_response(handle_service_uri)
    if res.is_a?(Net::HTTPSuccess)
      xml = Nokogiri.parse(res.body)
      handle = xml.xpath('//handlehttp').first.text
      self.ead_location = handle
      save
    end
    self
  end

  # Class methods to be added to Resource class
  module ClassMethods
    def add_handle(id)
      resource = Resource.get_or_die(id)
      resource.mint_handle!
    end

    def create_from_json(json, opts)
      json = super

      add_handle(json[:id]) if json[:ead_location].nil?

      json
    end
  end
end
