# frozen_string_literal: true

require_relative "touringplans/version"
require "httparty"
require "ostruct"
require 'representable/json'
require 'dry-struct'


# list and show attractions and eateries at Walt Disney World
module Touringplans
  class Error < StandardError; end
  # Your code goes here...
    include HTTParty
    # currently Touring Plans has no verision in its API
    DEFAULT_API_VERSION = "1"
    DEFAULT_BASE_URI  = "https://touringplans.com/"
    DEFAULT_QUERY     = {}

    base_uri DEFAULT_BASE_URI

  ROUTES = {
    magic_kingdom_dining: {
      method: "get",
      path: "/magic-kingdom/dining.json"
    },
    magic_kingdom_attractions: {
      method: "get",
      path: "/magic-kingdom/attractions.json"
    },
    animal_kingdom_dining: {
      method: "get",
      path: "/animal-kingdom/dining.json"
    },
    animal_kingdom_attractions: {
      method: "get",
      path: "/animal-kingdom/attractions.json"
    },
    epcot_dining: {
      method: "get",
      path: "/epcot/dining.json"
    },
    epcot_attractions: {
      method: "get",
      path: "/epcot/attractions.json"
    },
    hollywood_studios_dining: {
      method: "get",
      path: "/hollywood-studios/dining.json"
    },
    hollywood_studios_attractions: {
      method: "get",
      path: "/hollywood-studios/attractions.json"
    }
  }

  class Connection
    # concerned only on where it gets the info it needs
    # and maybe a version number

    include HTTParty
    # currently Touring Plans has no verision in its API
    DEFAULT_API_VERSION = "1"
    DEFAULT_BASE_URI  = "https://touringplans.com/"
    DEFAULT_QUERY     = {}

    base_uri DEFAULT_BASE_URI

    def initialize(options={})
      @api_version = options.fetch(:api_version, DEFAULT_API_VERSION)
      @query       = options.fetch(:query, DEFAULT_QUERY)
      @connection  = self.class
    end

    def query(params={})
      @query.update(params)
    end
    
    def get(relative_path, query={})
      # relative_path = add_api_version(relative_path)
      connection.get relative_path, query: @query.merge(query)
    end

    private

    attr_reader :connection
    # currently Touring Plans has no verision in its API

    # def add_api_version(relative_path)
    #   "/#{api_version_path}#{relative_path}"
    # end

    # def api_version_path
    #   "v" + @api_version.to_s
    # end    
  end

  class Client
    def initialize(connection:, routes:)
      @connection = connection
      @routes     = routes
    end

    def method_missing(method, *request_arguments)

      # retrieve the route map
      route_map = routes.fetch(method)

      # make request via the connection
      response_from_route(route_map, request_arguments)
    end

    private

    attr_reader :connection, :routes

    def response_from_route(route_map, request_arguments)

      # gather the routes required parameters
      http_method   = route_map.fetch(:method)
      relative_path = route_map.fetch(:path)

      # call the connection for records
      connection.send(http_method, relative_path, *request_arguments)
    end
  end
  
  class Song
    
  end

  class SongRepresenter < Representable::Decorator
    include Representable::JSON

    property :title
    property :track
  end


  class Attraction < OpenStruct; end

  class AttractionRepresenter < Representable::Decorator
    include Representable::JSON

    property :name
    property :short_name
    property :permalink
  end

  class AttractionHashRepresenter < Representable::Decorator
    include Representable::Hash
    include Representable::Hash::AllowSymbols
  
    property :name
    property :short_name
    property :permalink
  end

  PARK_KEYS = %i[magic_kingdom animal_kingdom epcot hollywood_studios].freeze
  # list interest at location
  # current interest are "counter service" "table service", and  "attractions"
  # current locations are the four parks
  def self.list(interest, location)
    
    return "The location is not a Disney park" unless PARK_KEYS.include? _symbolize(location)

    interest_type = _determine_interest_type(interest)
    formatted_location_name = _format_location_name(location)
    get("/#{formatted_location_name}/#{interest_type}.json").parsed_response
  end

  def self._format_location_name(location_name)
    location_name.to_s.downcase.gsub(" ", "-")
  end

  def self._determine_interest_type(interest)
    interest_type = interest

    interest_type = "dining" if interest == "counter service"
    interest_type = "dining" if interest == "table service"

    interest_type
  end

  def self._symbolize(location)
    # turn a string into a symbol, like comparing to PARK_KEYS
    location.downcase.gsub(" ", "_").to_sym
  end
end
