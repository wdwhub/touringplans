# frozen_string_literal: true

require_relative "touringplans/version"
require "httparty"
require "dry-struct"

# list and show attractions and eateries at Walt Disney World
module Touringplans
  class Error < StandardError; end

  module Types
    include Dry.Types()
  end

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
    },
    walt_disney_world_hotels: {
      method: "get",
      path: "/walt-disney-world/hotels.json"
    },
    walt_disney_world_campground: {
      method: "get",
      path: "/walt-disney-world/hotels.json"
    },
    walt_disney_world_deluxe_hotels: {
      method: "get",
      path: "/walt-disney-world/hotels.json"
    },
    walt_disney_world_deluxe_villas: {
      method: "get",
      path: "/walt-disney-world/hotels.json"
    },
    walt_disney_world_moderate_hotels: {
      method: "get",
      path: "/walt-disney-world/hotels.json"
    },
    walt_disney_world_value_hotels: {
      method: "get",
      path: "/walt-disney-world/hotels.json"
    },
    walt_disney_world_disney_springs_resorts: {
      method: "get",
      path: "/walt-disney-world/hotels.json"
    }
  }.freeze

  def self.routes
    ROUTES
  end

  # deals solely with how to create access to the resource, the lock of "lock & key"
  class Connection
    # concerned only on where it gets the info it needs
    # and maybe a version number

    include HTTParty
    # currently Touring Plans has no verision in its API
    DEFAULT_API_VERSION = "1"
    DEFAULT_BASE_URI  = "https://touringplans.com/"
    # do not freeze DEFAULT_QUERY
    DEFAULT_QUERY     = {}

    base_uri DEFAULT_BASE_URI

    def initialize(options = {})
      @api_version = options.fetch(:api_version, DEFAULT_API_VERSION)
      @query       = options.fetch(:query, DEFAULT_QUERY)
      @connection  = self.class
    end

    def query(params = {})
      @query.update(params)
    end

    def get(relative_path, query = {})
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

  # deals solely with how to manage the connection, the key of "lock & key"
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

  # Generates and updates routes for all types of venues in a YAML document.
  class RoutesTable
    require "fileutils"
    def initialize(filename: "routes_table.yml")
      @filename = filename
    end

    def self.original_routes
      # this method exists so that we can create a yaml file of routes
      tpr = Touringplans.routes
      # convert symbols back to strings
      stringify_keys(tpr)
      # rt_keys       = tpr.keys
      # rt_values     = tpr.values
      # string_keys   = []

      # rt_keys.each {|k| string_keys << k.to_s}
      # # create new hash with string keys
      # string_keys.zip(rt_values).to_h
    end

    def self.symbolize_keys(hash)
      hash.each_with_object({}) do |(key, value), result|
        new_key = case key
                  when String then key.to_sym
                  else key
                  end
        new_value = case value
                    when Hash then symbolize_keys(value)
                    else value
                    end
        result[new_key] = new_value
      end
    end

    def self.stringify_keys(hash)
      # inspired by https://avdi.codes/recursively-symbolize-keys/
      hash.each_with_object({}) do |(key, value), result|
        new_key = case key
                  when Symbol then key.to_s
                  else key
                  end
        new_value = case value
                    when Hash then stringify_keys(value)
                    else value
                    end
        result[new_key] = new_value
      end
    end

    def self.load_routes_file(routes_relative_file_path: "/routes.yml")
      tp_path = $LOAD_PATH.grep(/touringplans/).last
      routes_file = "#{tp_path}#{routes_relative_file_path}"
      YAML.safe_load(File.read(routes_file))
    end

    def self.update_file
      # gather info into hashes
      attractions_routes    = _generate_interest_routes_hash("attractions")
      dining_routes         = _generate_interest_routes_hash("dining")
      hotels_routes         = _generate_interest_routes_hash("hotels")
      updated_routes        = original_routes.merge(attractions_routes, dining_routes, hotels_routes)

      updated_routes_yaml   = _convert_hash_to_yaml(updated_routes)

      file = _initialize_file
      _save_content_to_file(file, updated_routes_yaml)
    end

    def self._initialize_file
      # delete old file if it exits
      lib_dir = FileUtils.getwd + "/lib"
      routes_file = "#{lib_dir}/routes.yml"

      # ensure the file exists
      touched_routes_file_array = FileUtils.touch(routes_file)
      # we want the first string value
      touched_routes_file_array.first
    end

    def self._generate_interest_routes_hash(interest)
      interest_venues = Touringplans.list_all(interest)
      interest_routes = {}

      interest_venues.each do |iv|
        new_route = _generate_interest_route(iv.venue_permalink, interest, iv.permalink)
        key = new_route.keys.first
        values = new_route[key]
        interest_routes[key] = values
      end

      interest_routes
    end

    def self._generate_interest_route(venue_permalink, interest_permalink, place_permalink)
      # {magic_kingdom_attractions_haunted_mansion: {
      #   method: "get",
      #   path: "/magic-kingdom/attractions/haunted-mansion.json"
      #   }
      # }
      path    = "/#{venue_permalink}/#{interest_permalink}/#{place_permalink}"
      key     = path.to_s.downcase.gsub("/", " ").gsub("-", " ").strip
      key     = key.gsub(" ", "_")
      method  = "get"
      format  = "json"

      { key => { "method".to_s => method,
                 "path".to_s => "#{path}.#{format}" } }
    end

    def self._convert_hash_to_yaml(hash)
      hash.to_yaml
    end

    def self._save_content_to_file(file, content)
      new_file = File.open(file, "w")
      new_file.write(content)
      new_file.close
    end

    def self._read_file_to_terminal(file)
      new_file = File.open(file, "r")
      new_file.close
    end
  end

  # model with the attributes
  class CounterServiceLocation < Dry::Struct
    transform_keys(&:to_sym)

    attribute :id, Types::Integer
    attribute :land_id, Types::Integer
    attribute :name, Types::String
    attribute :permalink, Types::String
    attribute :category_code, Types::String
    attribute :portion_size, Types::String.optional
    attribute :cost_code, Types::String.optional
    attribute :cuisine, Types::String
    attribute :phone_number, Types::String.optional
    attribute :entree_range, Types::String.optional
    attribute :when_to_go, Types::String.optional
    attribute :parking, Types::String.optional
    attribute :bar, Types::String.optional
    attribute :wine_list, Types::String.optional
    attribute :dress, Types::String.optional
    attribute :awards, Types::String.optional
    attribute :breakfast_hours, Types::String.optional
    attribute :lunch_hours, Types::String.optional
    attribute :dinner_hours, Types::String.optional
    attribute :selection, Types::String.optional
    attribute :setting_atmosphere, Types::String.optional
    attribute :other_recommendations, Types::String.optional
    attribute :summary, Types::String.optional
    attribute :house_specialties, Types::String.optional
    attribute :counter_quality_rating, Types::String.optional
    attribute :counter_value_rating, Types::String.optional
    attribute :table_quality_rating, Types::String.optional
    attribute :table_value_rating, Types::String.optional
    attribute :overall_rating, Types::Float.optional
    attribute :service_rating, Types::String.optional
    attribute :friendliness_rating, Types::String.optional
    attribute :adult_breakfast_menu_url, Types::String.optional
    attribute :adult_lunch_menu_url, Types::String.optional
    attribute :adult_dinner_menu_url, Types::String.optional
    attribute :child_breakfast_menu_url, Types::String.optional
    attribute :child_lunch_menu_url, Types::String.optional
    attribute :child_dinner_menu_url, Types::String.optional
    attribute :requires_credit_card, Types::Params::Bool
    attribute :requires_pre_payment, Types::Params::Bool
    attribute :created_at, Types::Params::DateTime
    attribute :updated_at, Types::Params::DateTime
    attribute :plan_x_coord, Types::Coercible::Integer.optional
    attribute :plan_y_coord, Types::Coercible::Integer.optional
    attribute :old_park_id, Types::Params::Integer.optional
    attribute :old_attraction_id, Types::Params::Integer.optional
    attribute :plan_name, Types::String.optional
    attribute :extinct_on, Types::Params::DateTime.optional
    attribute :opened_on, Types::Params::DateTime.optional
    attribute :disney_permalink, Types::String.optional
    attribute :code, Types::String.optional
    attribute :short_name, Types::String.optional
    attribute :accepts_reservations, Types::Params::Bool
    attribute :kosher_available, Types::Params::Bool
    attribute :dinable_id, Types::Params::Integer
    attribute :dinable_type, Types::String.optional
    attribute :venue_permalink, Types::String.optional
  end

  # model with the attributes
  class TableServiceLocation < Dry::Struct
    transform_keys(&:to_sym)

    attribute :id, Types::Integer
    attribute :land_id, Types::Integer
    attribute :name, Types::String
    attribute :permalink, Types::String
    attribute :category_code, Types::String
    attribute :portion_size, Types::String.optional
    attribute :cost_code, Types::String.optional
    attribute :cuisine, Types::String
    attribute :phone_number, Types::String.optional
    attribute :entree_range, Types::String.optional
    attribute :when_to_go, Types::String.optional
    attribute :parking, Types::String.optional
    attribute :bar, Types::String.optional
    attribute :wine_list, Types::String.optional
    attribute :dress, Types::String.optional
    attribute :awards, Types::String.optional
    attribute :breakfast_hours, Types::String.optional
    attribute :lunch_hours, Types::String.optional
    attribute :dinner_hours, Types::String.optional
    attribute :selection, Types::String.optional
    attribute :setting_atmosphere, Types::String.optional
    attribute :other_recommendations, Types::String.optional
    attribute :summary, Types::String.optional
    attribute :house_specialties, Types::String.optional
    attribute :counter_quality_rating, Types::String.optional
    attribute :counter_value_rating, Types::String.optional
    attribute :table_quality_rating, Types::Params::Decimal.optional
    attribute :table_value_rating, Types::Params::Decimal.optional
    attribute :overall_rating, Types::Params::Decimal.optional
    attribute :service_rating, Types::Params::Decimal.optional
    attribute :friendliness_rating, Types::Params::Decimal.optional
    attribute :adult_breakfast_menu_url, Types::String.optional
    attribute :adult_lunch_menu_url, Types::String.optional
    attribute :adult_dinner_menu_url, Types::String.optional
    attribute :child_breakfast_menu_url, Types::String.optional
    attribute :child_lunch_menu_url, Types::String.optional
    attribute :child_dinner_menu_url, Types::String.optional
    attribute :requires_credit_card, Types::Params::Bool
    attribute :requires_pre_payment, Types::Params::Bool
    attribute :created_at, Types::Params::DateTime
    attribute :updated_at, Types::Params::DateTime
    attribute :plan_x_coord, Types::Params::Integer.optional
    attribute :plan_y_coord, Types::Params::Integer.optional
    attribute :old_park_id, Types::Params::Integer.optional
    attribute :old_attraction_id, Types::Params::Integer.optional
    attribute :plan_name, Types::String.optional
    attribute :extinct_on, Types::Params::DateTime.optional
    attribute :opened_on, Types::Params::DateTime.optional
    attribute :disney_permalink, Types::String.optional
    attribute :code, Types::String.optional
    attribute :short_name, Types::String.optional
    attribute :accepts_reservations, Types::Params::Bool
    attribute :kosher_available, Types::Params::Bool
    attribute :dinable_id, Types::Params::Integer
    attribute :dinable_type, Types::String.optional
    attribute :venue_permalink, Types::String.optional
  end

  # model with the attributes
  class ParkAttraction < Dry::Struct
    transform_keys(&:to_sym)

    attribute :name, Types::String
    attribute :short_name, Types::String
    attribute :permalink, Types::String
    attribute :venue_permalink, Types::String
  end

  # model with the attributes
  class Hotel < Dry::Struct
    transform_keys(&:to_sym)

    attribute :name, Types::String
    attribute :sort_name, Types::String
    attribute :permalink, Types::String
    attribute :category_code, Types::String.optional
    attribute :venue_permalink, Types::String.optional
  end

  PLACE_KEYS          = %i[magic_kingdom
                           animal_kingdom
                           epcot
                           hollywood_studios
                           walt_disney_world].freeze
  # {interest:"interest_type"}
  INTERESTS           = %i[counter_services
                           table_services
                           attractions
                           hotels
                           campground
                           deluxe_hotels
                           deluxe_villas
                           moderate_hotels
                           value_hotels
                           disney_springs_resorts].freeze
  HOTEL_CATEGORIES = %i[campground
                        deluxe_hotels
                        deluxe_villas
                        moderate_hotels
                        value_hotels
                        disney_springs_resorts].freeze

  # list interest at location
  # current interest are "counter service" "table service", and  "attractions"
  # current locations are the four parks
  def self.list(interest, location)
    return "The location is not on Disney property" unless PLACE_KEYS.include? _symbolize(location)
    return "The interest is not valid" unless INTERESTS.include? _symbolize(interest)

    client = _setup_client
    listings            = []
    interest_type       = _determine_interest_type(interest)
    route               = _assemble_route(location, interest_type)
    response            = client.send(route).parsed_response
    listing_hashes      = _collect_listing_hashes_from_response(interest, response)
    listing_hashes.each do |item|
      item["venue_permalink"] = location.to_s.downcase.gsub(" ", "-").gsub("_", "-")
    end

    listing_hashes.each do |hash|
      listing = _set_model_from_hash(interest, hash)
      listings << listing
    end

    listings = list_hotels_of_a_category(listings, interest) if HOTEL_CATEGORIES.include? _symbolize(interest)

    listings
  end

  def self.list_all(interest_type)
    return "The interest_type is not valid" unless %i[dining attractions hotels].include? _symbolize(interest_type)

    parks   = ["Magic Kingdom", "Animal Kingdom", "Epcot", "Hollywood Studios"]
    places  = []

    if interest_type == "attractions"
      parks.each do |park|
        list = Touringplans.list("attractions", park)
        places << list
      end
    end

    if interest_type == "dining"
      parks.each do |park|
        list = Touringplans.list("counter services", park)
        places << list
        list = Touringplans.list("table services", park)
        places << list
      end
    end

    if interest_type == "hotels"
      HOTEL_CATEGORIES.each do |category|
        list = Touringplans.list(category.to_s, "walt_disney_world")
        places << list
      end
    end

    places.flatten
  end

  def self.show(interest_type, short_name)
    return "The interest_type is not valid" unless %i[dining attractions hotels].include? _symbolize(interest_type)

    # get a list of every model of one kind of interest_type (dining, attractions, hotels)
    places = list_all(interest_type)

    # filter by short_name
    places.find  { |place| place.short_name == short_name }
  end

  def self._setup_client
    connection = Connection.new
    connection.query(key: "HowdyLen")
    routes = Touringplans::RoutesTable.symbolize_keys(Touringplans::RoutesTable.load_routes_file)
    Client.new(connection: connection, routes: routes)
  end

  def self._format_location_name(location_name)
    location_name.to_s.downcase.gsub(" ", "-")
  end

  def self._determine_interest_type(interest)
    interest_type = interest

    interest_type = "dining" if interest == "counter services"
    interest_type = "dining" if interest == "table services"
    interest_type = "hotels" if %i[campground deluxe_hotels deluxe_villas moderate_hotels value_hotels disney_springs_resorts].include? _symbolize(interest)

    interest_type
  end

  def self._symbolize(item)
    ## turn a Stringinto a symbol, like comparing to PLACE_KEYS
    # if item is a path or name we need to turn it into a phrase of words
    str = item.to_s.downcase.gsub("/", " ").gsub("-", " ").strip
    # turn item into a symbol
    str = str.gsub(" ", "_")
    str.to_sym
  end

  def self._assemble_route(location, interest_type)
    formatted_location      = location.to_s.downcase.gsub(" ", "_")
    formatted_interest_type = interest_type.to_s.downcase.gsub(" ", "_")
    "#{formatted_location}_#{formatted_interest_type}"
  end

  def self._collect_listing_hashes_from_response(interest, response)
    hotel_categories = %i[campground deluxe_hotels deluxe_villas moderate_hotels value_hotels disney_springs_resorts]

    listing_hashes = response     if interest == "attractions"
    listing_hashes = response     if interest == "dining"
    listing_hashes = response[0]  if interest == "counter services"
    listing_hashes = response[1]  if interest == "table services"

    listing_hashes = list_all_hotels(response) if interest == "hotels"
    listing_hashes = list_all_hotels(response) if hotel_categories.include? _symbolize(interest)

    listing_hashes
  end

  def self.list_all_hotels(response_from_touringplans_hotels_url)
    listing_hashes = []

    response_from_touringplans_hotels_url.each do |child|
      child.each do |grandchild|
        listing_hashes << grandchild if grandchild.class.to_s == "Array"
      end
    end

    listing_hashes.flatten
  end

  # search for hotels of a category_code
  def self.list_hotels_of_a_category(hotels, interest)
    hotel_categories = { campground: "campground", deluxe_hotels: "deluxe",
                         deluxe_villas: "deluxe_villa", moderate_hotels: "moderate",
                         value_hotels: "value", disney_springs_resorts: NilClass }
    # get a list of every hotel model

    # filter by category_code
    # disney springs category code is null.  We need to find a rule for finding those that don't have any of the values of
    # hotel categories
    if interest == "disney springs resorts"
      hotels.find_all { |hotel| hotel.category_code.instance_of?(NilClass) }

    else
      hotels.find_all { |hotel| hotel.category_code == hotel_categories[_symbolize(interest)] }

    end
  end

  def generate_route_table
    # initial_routes = ROUTES
  end

  def self._set_model_from_hash(interest, hash)
    hotel_categories = %i[campground deluxe_hotels deluxe_villas moderate_hotels value_hotels disney_springs_resorts hotels]

    listing = CounterServiceLocation.new(hash)  if interest == "counter services"
    listing = TableServiceLocation.new(hash)    if interest == "table services"
    listing = ParkAttraction.new(hash)          if interest == "attractions"
    listing = Hotel.new(hash)                   if hotel_categories.include? _symbolize(interest)
    listing
  end
end
