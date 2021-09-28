# frozen_string_literal: true

RSpec.describe Touringplans do
  it "has a version number" do
    expect(Touringplans::VERSION).not_to be nil
  end

  describe "as a user I would like to list eateries and attractions" do
      connection = Touringplans::Connection.new
      connection.query(key: "HowdyLen")
      client = Touringplans::Client
               .new(connection: connection, routes: Touringplans::ROUTES)


    module Types
      include Dry.Types()
    end

    
    class Attraction < Dry::Struct
      transform_keys(&:to_sym)

      attribute :name, Types::String
      attribute :short_name, Types::String
      attribute :permalink, Types::String
    end


    context "at Magic Kingdom" do
      it "supports listing dining locations" do
        response = client.magic_kingdom_dining
        expect(response.parsed_response.length).to eq(2)
      end
    
      it "supports listing counter service locations as a collection" do
        response                        = client.magic_kingdom_dining
        counter_service_listings        =[]
        counter_service_listings_hashes = response.parsed_response[0]

        counter_service_listings_hashes.each do |hash|
          counter_service = Touringplans::CounterServiceLocation.new(hash)
          counter_service_listings << counter_service
        end
        expect(counter_service_listings.length).to eq(11)
      end

      it "supports listing a collection of CounterServiceLocation objects" do
        response                        = client.magic_kingdom_dining
        counter_service_listings        =[]
        counter_service_listings_hashes = response.parsed_response[0]

        counter_service_listings_hashes.each do |hash|
          counter_service = Touringplans::CounterServiceLocation.new(hash)
          counter_service_listings << counter_service
        end
        expect(counter_service_listings.last).to eq("something")
      end


      it "supports listing table service locations" do
        response                = client.magic_kingdom_dining
        table_service_listings  = response.parsed_response[1]
        expect(table_service_listings.length).to eq(8)
      end
      it "supports listing attractions" do
        response      = client.magic_kingdom_attractions
        attractions   = response.parsed_response
        expect(attractions.length).to eq(58)
      end      
    end

    ########################    
    context "at Animal Kingdom" do
      it "supports listing dining locations" do
        response = client.animal_kingdom_dining
        expect(response.parsed_response.length).to eq(2)
      end

      it "supports listing counter service locations" do
        response                  = client.animal_kingdom_dining
        counter_service_listings  = response.parsed_response[0]
        expect(counter_service_listings.length).to eq(11)
      end

      it "supports listing table service locations" do
        response                = client.animal_kingdom_dining
        table_service_listings  = response.parsed_response[1]
        expect(table_service_listings.length).to eq(4)
      end

      it "supports listing attractions" do
        response      = client.animal_kingdom_attractions
        attractions   = response.parsed_response
        expect(attractions.length).to eq(41)
      end
      
    end
    
    ########################    
    context "at Epcot" do
      it "supports listing dining locations" do
        response = client.epcot_dining
        expect(response.parsed_response.length).to eq(2)
      end

      it "supports listing counter service locations" do
        response                  = client.epcot_dining
        counter_service_listings  = response.parsed_response[0]
        expect(counter_service_listings.length).to eq(16)
      end

      it "supports listing table service locations" do
        response                = client.epcot_dining
        table_service_listings  = response.parsed_response[1]
        expect(table_service_listings.length).to eq(20)
      end

      it "supports listing attractions" do
        response      = client.epcot_attractions
        attractions   = response.parsed_response
        expect(attractions.length).to eq(33)
      end
      
    end

    ########################
    context "at Hollywood Studios" do
      it "supports listing dining locations" do
        response = client.hollywood_studios_dining
        expect(response.parsed_response.length).to eq(2)
      end

      it "supports listing counter service locations" do
        response                  = client.hollywood_studios_dining
        counter_service_listings  = response.parsed_response[0]
        expect(counter_service_listings.length).to eq(11)
      end

      it "supports listing table service locations" do
        response                = client.hollywood_studios_dining
        table_service_listings  = response.parsed_response[1]
        expect(table_service_listings.length).to eq(6)
      end

      it "supports listing attractions" do
        response      = client.hollywood_studios_attractions
        attractions   = response.parsed_response
        expect(attractions.length).to eq(30)
      end      
    end
    
  end

  # describe "dry-struct" do
  #   require 'dry-struct'

  #   module Types
  #     include Dry.Types()
  #   end

  #   class Attraction < Dry::Struct
  #       transform_keys(&:to_sym)
  #     attribute :name, Types::String
  #     attribute :short_name, Types::String
  #     attribute :permalink, Types::String
  #   end
    
    
  #   context "when trying to coerce hash" do
  #     class Person < Dry::Struct
  #       attribute :name, Types::String
  #       attribute :age, Types::Integer
  #     end

  #     it "becomes an ostruct" do
  #       hash = {name:"Johnson", age: 21}
  #       person = Person.new(hash)
  #       expect(person.name).to eq("Johnson") 
  #     end
  #   end

  #   context "when trying to coerce an attraction" do
  #     it "becomes an ostruct" do
  #       ride = {"name":"The American Adventure","short_name":"American Adv","permalink":"american-adventure"}
  #       attraction = Attraction.new(ride)
  #       expect(attraction.permalink).to eq("american-adventure") 
  #     end
  #   end

  #   context "when trying to coerce an array of attraction hashes" do
  #     rides = Touringplans.list("attractions", "Epcot")
  #     new_attraction = Attraction.new({"name":"The American Adventure",
  #                                       "short_name":"American Adv",
  #                                       "permalink":"american-adventure"})

  #     it "becomes an array of Attraction objects" do
  #       attractions = []
  #       rides.each do |ride|
  #         attraction = Attraction.new(ride)
  #         attractions << attraction
  #       end

  #       expect(attractions.first.class).to eq(new_attraction.class) 
  #     end
  #   end
    
  # end
  
  describe "representable" do
    json_results        = HTTParty.get('https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY', format: :plain)

    it "turns attraction json into an object representation" do
      ride = Touringplans::Attraction.new
      ride = Touringplans::AttractionRepresenter.new(ride).from_json(%{ {"name":"dumbo"} })    
      expect(ride.title).to eq("dumbo")
    end

    context "when working with touring plans" do
      require 'httparty'
      epcot_json_results  = HTTParty.get('https://touringplans.com/epcot/attractions.json', format: :plain)
      epcot_results       = HTTParty.get('https://touringplans.com/epcot/attractions.json')
      ride = Touringplans::Attraction.new
      # ride = Touringplans::AttractionRepresenter.new(ride).from_json(epcot_json_results[0][0])    

      it "can convert an attraction hash collection into an ostruct collection" do
        # ride = Touringplans::AttractionHashRepresenter.new(ride)
        # converted = ride.from_hash("title" => "Road To Never")
        expect(epcot_json_results).to eq("something") 
      end

      it "can convert json to ruby objects" do
        epcot_sample = {name:"The American Adventure",short_name:"American Adv",permalink:"american-adventure"}
        ride = Touringplans::AttractionRepresenter.new(ride).from_json(%{ {"name":"The American Adventure","short_name":"American Adv","permalink":"american-adventure"} })    
        expect(ride).to eq("something") 
        
      end
      # json_results        = HTTParty.get('https://touringplans.com/epcot/attractions.json', format: :plain)
      it "can convert hash to ruby objects" do
        epcot_sample = {name:"The American Adventure",short_name:"American Adv",permalink:"american-adventure"}
        ride = Touringplans::AttractionRepresenter.new(ride).from_json({name:"The American Adventure",short_name:"American Adv",permalink:"american-adventure"})    
        expect(ride).to eq("something") 
        
      end
      
      
    end
    
    
  end

  describe ".list" do
    it "supports listing counter service dining locations in Magic Kingdom" do
      expect(Touringplans.list("counter service", "Magic Kingdom")[0].length).to eq(11)
    end

    it "supports listing table service dining locations in Magic Kingdom" do
      expect(Touringplans.list("table service", "Magic Kingdom")[1].length).to eq(8)
    end

    it "supports listing attractions in Magic Kingdom" do
      expect(Touringplans.list("attractions", "Magic Kingdom").length).to eq(58)
    end
    ########################
    it "supports listing counter service dining locations in Animal Kingdom" do
      expect(Touringplans.list("counter service", "Animal Kingdom")[0].length).to eq(11)
    end

    it "supports listing table service dining locations in Animal Kingdom" do
      expect(Touringplans.list("table service", "Animal Kingdom")[1].length).to eq(4)
    end

    it "supports listing attractions in Animal Kingdom" do
      expect(Touringplans.list("attractions", "Animal Kingdom").length).to eq(41)
    end

    ########################
    it "supports listing counter service dining locations in Epcot" do
      expect(Touringplans.list("counter service", "Epcot")[0].length).to eq(16)
    end

    it "supports listing table service dining locations in Epcot" do
      expect(Touringplans.list("table service", "Epcot")[1].length).to eq(20)
    end

    it "supports listing attractions in Epcot" do
      expect(Touringplans.list("attractions", "Epcot").length).to eq(33)
    end

    ########################
    it "supports listing counter service dining locations in Hollywood Studios" do
      expect(Touringplans.list("counter service", "Hollywood Studios")[0].length).to eq(11)
    end

    it "supports listing table service dining locations in Hollywood Studios" do
      expect(Touringplans.list("table service", "Hollywood Studios")[1].length).to eq(6)
    end

    it "supports listing attractions in Hollywood Studios" do
      expect(Touringplans.list("attractions", "Hollywood Studios").length).to eq(30)
    end
    ########################
    it "rejects the location if it is not a name of a wdw park" do
      expect(Touringplans.list("attractions", "Great America")).to eq("The location is not a Disney park")
    end
  end

  describe "._determine_interest_type" do
    it "sets interest_type to 'dining' when the interest is 'counter service'" do
      expect(Touringplans._determine_interest_type("counter service")).to  eq("dining")
    end

    it "sets interest_type to 'dining' when the interest is 'table service'" do
      expect(Touringplans._determine_interest_type("table service")).to  eq("dining")
    end

    it "sets interest_type to 'attractions' when the interest is 'attractions'" do
      expect(Touringplans._determine_interest_type("attractions")).to eq("attractions")
    end
  end
end
