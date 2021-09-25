# frozen_string_literal: true

require_relative "touringplans/version"
require "httparty"
module Touringplans
  class Error < StandardError; end
  # Your code goes here...\
  include HTTParty
  base_uri "touringplans.com"

  # park dining
  def self.find_all_dining_at_park(park_name)
    formatted_park_name = park_name.to_s.downcase.gsub(" ", "-")
    response = get("/#{formatted_park_name}/dining.json").parsed_response
  end

  def self.find_all_counter_service_dining_at_park(park_name)
    eateries = self.find_all_dining_at_park(park_name)
    eateries[0]
  end

  def self.find_all_table_service_dining_at_park(park_name)
    eateries = self.find_all_dining_at_park(park_name)
    eateries[1]
  end

  # park attractions
  def self.find_all_attractions_at_park(park_name)
    formatted_park_name = park_name.to_s.downcase.gsub(" ", "-")
    response = get("/#{formatted_park_name}/attractions.json").parsed_response
  end

end
