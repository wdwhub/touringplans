# frozen_string_literal: true

RSpec.describe Touringplans do
  it "has a version number" do
    expect(Touringplans::VERSION).not_to be nil
  end

  describe "#list" do
    context "at Magic Kingdom" do
      it "supports listing counter service dining locations" do
        expect(Touringplans.list("counter services", "Magic Kingdom").length).to eq(11)
        # expect(Touringplans.list("counter service", "Magic Kingdom")).to eq("something")
      end

      it "adds the park name as the location of the counter service" do
        expect(Touringplans.list("counter services", "Magic Kingdom").last.venue_permalink).to eq("magic-kingdom")        
      end

      it "supports listing table service dining locations" do
        expect(Touringplans.list("table services", "Magic Kingdom").length).to eq(8)
      end

      it "supports listing attractions" do
        expect(Touringplans.list("attractions", "Magic Kingdom").length).to eq(57)
      end

      it "adds the park name as the location of the attraction" do
        expect(Touringplans.list("attractions", "Magic Kingdom").last.venue_permalink).to eq("magic-kingdom")        
      end
      
    end
    ########################
    context "at Animal Kingdom" do
      it "supports listing counter service dining locations in Animal Kingdom" do
        expect(Touringplans.list("counter services", "Animal Kingdom").length).to eq(11)
      end

      it "supports listing table service dining locations in Animal Kingdom" do
        expect(Touringplans.list("table services", "Animal Kingdom").length).to eq(4)
      end

      it "supports listing attractions in Animal Kingdom" do
        expect(Touringplans.list("attractions", "Animal Kingdom").length).to eq(42)
      end
    end
    ########################
    context "at Epcot" do
      it "supports listing counter service dining locations in Epcot" do
        expect(Touringplans.list("counter services", "Epcot").length).to eq(16)
      end

      it "supports listing table service dining locations in Epcot" do
        expect(Touringplans.list("table services", "Epcot").length).to eq(20)
      end

      it "supports listing attractions in Epcot" do
        expect(Touringplans.list("attractions", "Epcot").length).to eq(36)
      end
    end
    ########################
    context "at Hollywood Studios" do
      it "supports listing counter service dining locations in Hollywood Studios" do
        expect(Touringplans.list("counter services", "Hollywood Studios").length).to eq(11)
      end

      it "supports listing table service dining locations in Hollywood Studios" do
        expect(Touringplans.list("table services", "Hollywood Studios").length).to eq(6)
      end

      it "supports listing attractions in Hollywood Studios" do
        expect(Touringplans.list("attractions", "Hollywood Studios").length).to eq(30)
      end
    end
    ########################
    it "rejects the location if it is not a name of a wdw park" do
      expect(Touringplans.list("attractions", "Great America")).to eq("The location is not on Disney property")
    end
    ########################
    context "at WDW hotels" do
      it "supports the listing of all hotels" do
        expect(Touringplans.list("hotels", "Walt Disney World").length).to eq(46)
      end
      
      it "supports the listing of the campground" do
        expect(Touringplans.list("campground", "Walt Disney World").length).to eq(1)
      end
# 
      it "supports the listing of all deluxe hotels" do
        expect(Touringplans.list("deluxe hotels", "Walt Disney World").length).to eq(13)
      end

      it "supports the listing of all deluxe_villas" do
        expect(Touringplans.list("deluxe villas", "Walt Disney World").length).to eq(14)
      end

      it "supports the listing of all moderate hotels" do
        expect(Touringplans.list("moderate hotels", "Walt Disney World").length).to eq(5)
      end

      it "supports the listing of all value hotels" do
        expect(Touringplans.list("value hotels", "Walt Disney World").length).to eq(5)
      end
      
      it "supports the listing of all disney springs resorts" do
        expect(Touringplans.list("disney springs resorts", "Walt Disney World").length).to eq(8)
      end
      
    end
    
  end

  describe "#show" do
    context "when looking for a dining location" do
      it "supports showing a counter service dining location" do
        expect(Touringplans.show("dining", "Cosmic Ray's").name).to eq("Cosmic Ray's Starlight Café")
      end

      it "supports showing a table service dining location" do
        expect(Touringplans.show("dining", "Cinderella's Table").name).to eq("Cinderella's Royal Table")
      end
    end

    context "when looking for an attraction" do
      it "supports showing a counter service dining location" do
        expect(Touringplans.show("attractions", "Astro Orbiter").permalink).to eq("astro-orbiter")
      end
    end
  end

  describe "._determine_interest_type" do
    it "sets interest_type to 'dining' when the interest is 'counter service'" do
      expect(Touringplans._determine_interest_type("counter services")).to eq("dining")
    end

    it "sets interest_type to 'dining' when the interest is 'table service'" do
      expect(Touringplans._determine_interest_type("table services")).to eq("dining")
    end

    it "sets interest_type to 'attractions' when the interest is 'attractions'" do
      expect(Touringplans._determine_interest_type("attractions")).to eq("attractions")
    end
  end

  describe "#list_all - as a user I want to" do
    it "list all of the dining locations in the parks" do
      expect(Touringplans.list_all("dining").length).to eq(87)
    end

    it "list all of the attractions in the parks" do
      expect(Touringplans.list_all("attractions").length).to eq(165)
    end

    context "not" do
      it "list just the counter services" do
        expect(Touringplans.list_all("counter services")).to eq("The interest_type is not valid")
      end

      it "list just the tables services" do
        expect(Touringplans.list_all("table services")).to eq("The interest_type is not valid")
      end
    end
  end
end
