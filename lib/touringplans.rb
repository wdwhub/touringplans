# frozen_string_literal: true

require_relative "touringplans/version"
require "httparty"

# list and show attractions and eateries at Walt Disney World
module Touringplans
  class Error < StandardError; end
  # Your code goes here...
  include HTTParty
  base_uri "touringplans.com"

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
