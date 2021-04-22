require 'uri'
require 'net/http'
require 'json'

# This mixin adds the funcationality to mint a handle from the handle service
# and add it to a resource's ead_location field.
module EADLocationGenerator
  def self.included(base)
    base.extend(ClassMethods)
  end

  def public_url
    File.join(AppConfig[:public_proxy_url], uri)
  end

  def mint_handle!
    # Retrieve configuration parameters
    handle_service_uri = URI(AppConfig[:umd_handle_server_url])
    handle_jwt_token = AppConfig[:umd_handle_jwt_token]
    handle_prefix = AppConfig[:umd_handle_prefix]
    handle_repo = AppConfig[:umd_handle_repo]

    # Prepare "repo_id" and "description" values
    handle_repo_id = "/repositories/#{self.repo_id}/resources/#{self.id}"
    handle_description = self.title.nil? ? '' : self.title

    # Setup header with JWT token authentication
    headers =  {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{handle_jwt_token}",
      'Accept' => 'application/json'
    }

    # Setup POST request
    request = Net::HTTP::Post.new(handle_service_uri, headers)
    # POST request body as defined in umd-handle API v1.0.0.
    request.body = {
      prefix: handle_prefix,
      url: "#{public_url}",
      repo: handle_repo,
      repo_id: handle_repo_id,
      description: handle_description,
      notes: ''
    }.to_json

    # Make request
    use_ssl = (handle_service_uri.scheme == "https")
    response = Net::HTTP.start(handle_service_uri.hostname, handle_service_uri.port, use_ssl: use_ssl) do |http|
      http.request(request)
    end

    # Process response
    if response.is_a?(Net::HTTPSuccess)
      parsed_body = JSON.parse(response.body)
      handle_url = parsed_body['handle_url']
      if handle_url
        # If handle_url provided in response, update this resource
        self.ead_location = handle_url
        save
      end
    else
      # Log an error for unsuccessful response
      Log.error("Could not mint handle for repo_id: #{self.repo_id}, resource id: #{self.id}")
      Log.error("Received a response status code of '#{response.code} - #{response.message}' from '#{handle_service_uri}'")
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
