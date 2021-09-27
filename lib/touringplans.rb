# frozen_string_literal: true

require_relative "touringplans/version"
require "httparty"

# list and show attractions and eateries at Walt Disney World
module Touringplans
  class Error < StandardError; end
  # Your code goes here...
  include HTTParty
  base_uri "touringplans.com"

  # park dining
  def self.find_all_dining_at_park(park_name)
    formatted_park_name = _format_location_name(park_name)
    get("/#{formatted_park_name}/dining.json").parsed_response
  end

  # list interest at location
  # current interest are "counter service" "table service", and  "attractions"
  # current locations are the four parks
  def self.list(interest, location)
    # interest_type = interest # _determine_interest_type(interest)
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
end
