# frozen_string_literal: true

RSpec.describe Touringplans do
  it "has a version number" do
    expect(Touringplans::VERSION).not_to be nil
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
      expect(Touringplans.list("counter service", "Epcot")[0].length).to eq(17)
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
