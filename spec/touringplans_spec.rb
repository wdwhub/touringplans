# frozen_string_literal: true

RSpec.describe Touringplans do
  it "has a version number" do
    expect(Touringplans::VERSION).not_to be nil
  end

  describe ".list" do
    it "supports listing dining locations in Magic Kingdom" do
      expect(Touringplans.list("dining", "Magic Kingdom")[0][0]["sort_name"]).to eq("caseys corner")

    end

    it "supports listing attractions in Magic Kingdom" do
      expect(Touringplans.list("attractions", "Magic Kingdom").length).to eq(58)
    end
    ########################
    it "supports listing dining locations in Animal Kingdom" do
      expect(Touringplans.list("dining", "Animal Kingdom")[0][0]["sort_name"]).to eq("creature comforts")

    end

    it "supports listing attractions in Animal Kingdom" do
      expect(Touringplans.list("attractions", "Animal Kingdom").length).to eq(41)
    end

    ########################
    it "supports listing dining locations in Epcot" do
      expect(Touringplans.list("dining", "Epcot")[0][0]["sort_name"]).to eq("cantina de san angel")

    end

    it "supports listing attractions in Epcot" do
      expect(Touringplans.list("attractions", "Epcot").length).to eq(33)
    end

    ########################
    it "supports listing dining locations in Hollywood Studios" do
      expect(Touringplans.list("dining", "Hollywood Studios")[0][0]["sort_name"]).to eq("abc commissary")

    end

    it "supports listing attractions in Hollywood Studios" do
      expect(Touringplans.list("attractions", "Hollywood Studios").length).to eq(30)
    end

  end
end
