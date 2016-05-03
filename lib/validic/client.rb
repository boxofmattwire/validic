require 'faraday'
require 'faraday_middleware'

require 'validic/rest/apps'
require 'validic/rest/biometrics'
require 'validic/rest/diabetes'
require 'validic/rest/fitness'
require 'validic/rest/nutrition'
require 'validic/rest/organizations'
require 'validic/rest/profile'
require 'validic/rest/request'
require 'validic/rest/response'
require 'validic/rest/routine'
require 'validic/rest/sleep'
require 'validic/rest/tobacco_cessation'
require 'validic/rest/users'
require 'validic/rest/weight'
require 'validic/version'

module Validic
  class Client
    include REST::Apps
    include REST::Biometrics
    include REST::Diabetes
    include REST::Fitness
    include REST::Nutrition
    include REST::Organizations
    include REST::Profile
    include REST::Request
    include REST::Response
    include REST::Routine
    include REST::Sleep
    include REST::TobaccoCessation
    include REST::Users
    include REST::Weight

    attr_accessor :api_url,
      :api_version,
      :access_token,
      :organization_id

    ##
    # Create a new Validic::Client object
    #
    # @params options[Hash]
    def initialize(options={})
      @api_url          = options.fetch(:api_url, 'https://api.validic.com')
      @api_version      = options.fetch(:api_version, 'v1')
      @access_token     = options.fetch(:access_token, Validic.access_token)
      @organization_id  = options.fetch(:organization_id, Validic.organization_id)
      reload_config
    end

    ##
    # Create a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      Faraday.new(url: @api_url, headers: default_headers, ssl: { verify: true }) do |faraday|
        # faraday.use FaradayMiddleware::Mashify
        faraday.use FaradayMiddleware::ParseJson, content_type: /\bjson$/
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.adapter Faraday.default_adapter
      end
    end

    ##
    # If you want the RAW JSON only.
    #
    # @return JSON document
    def get_json_for(activity_type, options = {})
      get_request(activity_type, options)
    end

    def get_latest_json_for(activity_type, options = {})
      latest(activity_type, options)
    end

    private

    def default_headers
      {
        accept: 'application/json',
        content_type: 'application/json',
        user_agent: "Ruby Gem by Validic #{Validic::VERSION}"
      }
    end

    def reload_config
      Validic.api_url = api_url
      Validic.api_version = api_version
      Validic.access_token = access_token
      Validic.organization_id = organization_id
    end
  end
end
