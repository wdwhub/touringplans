# frozen_string_literal: true

# ## spec is a work in progress
RSpec.describe Touringplans do
  # ensure we have a current routing table
  # if we don't we will get a cryptic error:
  # undefined method `inject' for false:FalseClass
  # Touringplans::RoutesTable.update_file
  describe "RoutesTable" do
    context "when loading the routes.yaml file" do
      # subject = Touringplans::RoutesTable.load_routes_file
      # it "returns something" do
      #   expect(subject).to eq("something")
      # end
    end

    context "when updating the route.yml file" do
      Touringplans::RoutesTable.update_file

      # read file to inspect the contents
      lib_dir     =  FileUtils.getwd() + "/lib"
      routes_file = "#{lib_dir}/routes.yml"
      file_to_read = File.open(routes_file, "r")
      contents = file_to_read.read
      file_to_read.close

      it "writes a route to the routes_file" do
        Touringplans::RoutesTable.update_file
        routes = Touringplans::RoutesTable.symbolize_keys(Touringplans::RoutesTable.load_routes_file)

        expect(routes.fetch(:magic_kingdom_dining, "not found")).to eq({:method=>"get", :path=>"/magic-kingdom/dining.json"})
      end
    end

    context "when generating an interest route" do
      venue_permalink     = "magic-kingdom"
      interest_permalink  = "attractions"
      place_permalink     = "haunted-mansion"
      resulting_hash      = Touringplans::RoutesTable._generate_interest_route(venue_permalink, interest_permalink, place_permalink)
      it "creates a hash" do
        expect(resulting_hash.class.to_s).to eq("Hash")
      end

      it "creates one main key" do
        expect(resulting_hash.keys.length).to eq(1)
      end

      it "has a string for its one main key" do
        expect(resulting_hash.keys.first.class.to_s).to eq("String")
      end

      it "creates a hash as a value for its key" do
        expect(resulting_hash.values.first.class.to_s).to eq("Hash")
      end

    end

    context "when initializing the routes.yml file" do
      it "supports creating a blank routes.yml file in lib dir" do
        expect(Touringplans::RoutesTable._initialize_file).to include("lib\/routes.yml")
      end

      it "returns the full path of the file as a string" do
        expect(Touringplans::RoutesTable._initialize_file.class.to_s).to eq("String")
      end
    end

    context "when saving content to the routes.yml file" do
     ###*** this needs to be simplified
      tpr = Touringplans::RoutesTable
      # gather info into hashes
      attractions_routes    = tpr._generate_interest_routes_hash("attractions")
      dining_routes         = tpr._generate_interest_routes_hash("dining")
      hotels_routes         = tpr._generate_interest_routes_hash("hotels")
      updated_routes        = tpr.original_routes.merge(attractions_routes, dining_routes, hotels_routes)

      updated_routes_yaml   = tpr._convert_hash_to_yaml(updated_routes)

      file = tpr._initialize_file
      Touringplans::RoutesTable._save_content_to_file(file, updated_routes_yaml)
      # read file to inspect the contents
      file_to_read = File.open(file, "r")
      contents = file_to_read.read
      file_to_read.close

      it "supports adding content as a string" do
        expect(contents.class.to_s).to eq("String")
      end

      it "supports adding content as a string" do
        expect(contents).to include("magic_kingdom_dining")
      end

    end

    context "converting a hash to yaml" do
      hash = Touringplans.routes
      it "returns the routes in a yaml format" do
        expect(Touringplans::RoutesTable._convert_hash_to_yaml(hash).class.to_s).to eq("String")
      end
    end

    context "loading routes.yml" do
      Touringplans::RoutesTable.update_file
      result = Touringplans::RoutesTable.load_routes_file

      # it "something" do
      #   expect(result).to eq("something")
      # end

      it "returns a hash" do
        expect(result.class.to_s).to eq("Hash")
      end

      it "returns a string as the key for a route" do
        expect(result.first.first.class.to_s).to eq("String")
      end

      it "returns a hash as the value for a listing route" do
        expect(result.fetch("magic_kingdom_dining", "not found").class.to_s).to eq("Hash")
      end

      it "returns a path as a value for a listing route" do
        expect(result.fetch("magic_kingdom_dining", "not found").fetch("path").class.to_s).to eq("String")
      end

      it "returns a method of 'get' as a value for a listing route" do
        expect(result.fetch("magic_kingdom_dining", "not found").fetch("method")).to eq("get")
      end

      it "returns a hash as the value for a dining route" do
        expect(result.fetch("hollywood_studios_dining_roundup_rodeo_bbq", "not found").class.to_s).to eq("Hash")
      end

      it "returns a path as a value for a dining route" do
        expect(result.fetch("hollywood_studios_dining_roundup_rodeo_bbq", "not found").fetch("path").class.to_s).to eq("String")
      end

      it "returns a method of 'get' as a value for a dining route" do
        expect(result.fetch("hollywood_studios_dining_roundup_rodeo_bbq", "not found").fetch("method")).to eq("get")
      end

      # hollywood_studios_dining_roundup_rodeo_bbq
    end

    context "rendering orginal_routes without keys" do
      subject = Touringplans::RoutesTable.original_routes
      # it "returns something" do
      #   expect(subject).to eq("something")
      # end

      it "returns a hash" do
        expect(subject.class.to_s).to  eq("Hash")
      end

      it "returns a hash key that is the string 'magic_kingdom_attractions'" do
        expect(subject.fetch("magic_kingdom_attractions", "not found").fetch("path", "not found")).to eq("/magic-kingdom/attractions.json")
      end
    end
  end

  describe "RoutesTable._generate_interest_routes_hash(interest)" do
    interest  = "attractions"
    attractions_hash  = Touringplans::RoutesTable._generate_interest_routes_hash("attractions")
    dining_hash       = Touringplans::RoutesTable._generate_interest_routes_hash("dining")
    hotels_hash       = Touringplans::RoutesTable._generate_interest_routes_hash("hotels")

    it "creates a hash" do
      expect(attractions_hash.class.to_s).to eq("Hash")
    end
    
    it "creates many route keys" do
      expect(attractions_hash.keys.length).to be_between(150, 160)
    end

    it "creates a hash of routes for 'attractions'" do
      expect(attractions_hash.keys.length).to be_between(150, 160)
    end
    
    it "creates a hash of routes for 'dining'" do
      expect(dining_hash.keys.length).to be_between(80, 95)
    end

    it "creates a hash of routes for 'hotels'" do
      expect(hotels_hash.keys.length).to be_between(35, 45)
    end
    
  end
    
end
