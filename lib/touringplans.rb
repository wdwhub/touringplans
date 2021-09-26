# frozen_string_literal: true

require_relative "touringplans/version"
require "httparty"

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
  # current interest are dining, attractions
  # current locations are the four parks
  def self.list(interest, location)
    formatted_location_name = _format_location_name(location)
    get("/#{formatted_location_name}/#{interest}.json").parsed_response

  end
  
  def self._format_location_name(location_name)
    location_name.to_s.downcase.gsub(" ", "-")
  end
  
 
end
