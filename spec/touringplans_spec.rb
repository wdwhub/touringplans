# frozen_string_literal: true

RSpec.describe Touringplans do
  # ensure we have a current routing table
  # if we don't we will get a cryptic error:
  # undefined method `inject' for false:FalseClass
  # Touringplans::RoutesTable.update_file
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
        expect(Touringplans.list("attractions", "Epcot").length).to eq(37)
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
    context "when we want to just show something" do
    #   it "supports showing an attraction's details" do
    #     # magic_kingdom_attractions_casey_jr_splash_n_soak_station
    #     # https://touringplans.com/magic-kingdom/attractions/casey-jr-splash-n-soak-station.json
    #     # show(collection, interest_type, short_name) 
    #     expect(Touringplans.show("magic kingdom","attractions", "Astro Orbiter")).to eq("something")
    #   end      

    #   it "supports showing an dining venue's details" do
    #     # magic_kingdom_dining_cosmic_rays_starlight_cafe
    #     # https://touringplans.com/magic-kingdom/dining/cosmic-rays-starlight-cafe.json
    #     # show(collection, interest_type, short_name) 
    #     expect(Touringplans.show("magic kingdom", "dining", "columbia harbour house")).to eq("something")
    #   end      

    #   it "supports showing a hotel's details" do
    #     # walt_disney_world_hotels_disneys_grand_floridian_resort
    #     # https://touringplans.com/walt-disney-world/hotels/disneys-grand-floridian-resort.json
    #     expect(Touringplans.show("walt disney world", "hotels", "disneys polynesian resort")).to eq("something")
    #   end      
      context "with attractions" do
        interest = "attractions"

        it "confirms no attraction type errors in Animal Kingdom" do
          collection = "Animal Kingdom"
          # this runs through all of the attractions in animal kingdom
          # a success is seeing an array of attractions w/o errors
          attractions = Touringplans.list(interest, collection)
          subject = attractions.each {|a| Touringplans.show(collection,interest, a.permalink) }

          expect(subject.class.to_s).to eq("Array")
        end

        it "confirms no attraction type errors in Epcot" do
          # this runs through all of the attractions in magic kingdom
          # a success is seeing an array of attractions w/o errors
          collection = "epcot"
          attractions = Touringplans.list(interest, collection)
          subject = attractions.each {|a| Touringplans.show(collection,interest, a.permalink) }

          expect(subject.class.to_s).to eq("Array")
        end
        
        it "confirms no attraction type errors in Hollywood Studios" do
          # this runs through all of the attractions in magic kingdom
          # a success is seeing an array of attractions w/o errors
          collection = "hollywood studios"
          attractions = Touringplans.list(interest, collection)
          subject = attractions.each {|a| Touringplans.show(collection,interest, a.permalink) }

          expect(subject.class.to_s).to eq("Array")
        end
        
        it "confirms no attraction type errors in Magic Kingdom" do
          # this runs through all of the attractions in magic kingdom
          # a success is seeing an array of attractions w/o errors
          collection = "magic kingdom"
          attractions = Touringplans.list(interest, collection)
          subject = attractions.each {|a| Touringplans.show(collection,interest, a.permalink) }

          expect(subject.class.to_s).to eq("Array")
        end
        
      end
              
      context "with dining" do
        interest = "dining"

        it "confirms no dining type errors in Animal Kingdom" do
          # this runs through all of the dining venues in animal kingdom
          # a success is seeing an array of dining venues w/o errors
          collection = "Animal Kingdom"
          counter_services = Touringplans.list("counter services", collection)
          table_services = Touringplans.list("table services", collection)
          dining_services = table_services + counter_services

          subject = dining_services.each {|a| Touringplans.show(collection, interest, a.permalink) }

          expect(subject.class.to_s).to eq("Array")
        end

        it "confirms no dining type errors in Epcot" do
          # this runs through all of the dining venues in animal kingdom
          # a success is seeing an array of dining venues w/o errors
          collection = "Epcot"
          counter_services = Touringplans.list("counter services", collection)
          table_services = Touringplans.list("table services", collection)
          dining_services = table_services + counter_services

          subject = dining_services.each {|a| Touringplans.show(collection, interest, a.permalink) }

          expect(subject.class.to_s).to eq("Array")
        end
        
        it "confirms no dining type errors in Hollywood Studios" do
          # this runs through all of the dining venues in animal kingdom
          # a success is seeing an array of dining venues w/o errors
          collection = "Hollywood Studios"
          counter_services = Touringplans.list("counter services", collection)
          table_services = Touringplans.list("table services", collection)
          dining_services = table_services + counter_services

          subject = dining_services.each {|a| Touringplans.show(collection, interest, a.permalink) }

          expect(subject.class.to_s).to eq("Array")
        end
        
        it "confirms no dining type errors in Magic Kingdom" do
          # this runs through all of the dining venues in animal kingdom
          # a success is seeing an array of dining venues w/o errors
          collection = "Magic Kingdom"
          counter_services = Touringplans.list("counter services", collection)
          table_services = Touringplans.list("table services", collection)
          dining_services = table_services + counter_services

          subject = dining_services.each {|a| Touringplans.show(collection, interest, a.permalink) }

          expect(subject.class.to_s).to eq("Array")
        end
                
      end
    end

      context "with hotels" do
        interest = "hotels"
        hotels = Touringplans.list_all("hotels")

        it "confirms no hotels type errors in walt disney world" do
          # this runs through all of the hotels in walt disney world
          # a success is seeing an array of hotels w/o errors
          collection = "walt disney world"
          subject = hotels.each {|a| Touringplans.show(collection,interest, a.permalink) }

          expect(subject.class.to_s).to eq("Array")
        end        
      end
    
    context "when showing the details for a dining location" do
      context "counter service with a short_name" do
          venue = Touringplans.show("magic kingdom", "dining", "cosmic rays starlight cafe")
        it "supports name" do
          expect(venue.name).to eq("Cosmic Ray's Starlight Café")
        end        

        it "supports showing  the venue permalink" do
          expect(venue.permalink).to eq("cosmic-rays-starlight-cafe")
        end        

        it "supports showing  the venue category_code" do
          expect(venue.category_code).to eq("counter_service")
        end        

        it "supports portion_size" do
          expect(venue.portion_size).to eq("Large")
        end   

        it "supports cost_code" do
          expect(venue.cost_code).to eq("inexpensive")
        end        

        it "supports cuisine" do
          expect(venue.cuisine).to eq("American")
        end        

        it "supports phone_number" do
          expect(venue.phone_number).to eq(nil)
        end        

        it "supports entree_range" do
          expect(venue.entree_range).to eq("Lunch and Dinner: Adult $9-12")
        end        

        it "supports when_to_go" do
          expect(venue.when_to_go).to eq(nil)
        end        

        it "supports parking" do
          expect(venue.parking).to eq(nil)
        end        

        it "supports bar" do
          expect(venue.bar).to eq(nil)
        end        

        it "supports wine_list" do
          expect(venue.wine_list).to eq(nil)
        end        

        it "supports dress" do
          expect(venue.dress).to eq("Casual")
        end        

        it "supports awards" do
          expect(venue.awards).to eq(nil)
        end        

        it "supports breakfast_hours" do
          expect(venue.breakfast_hours).to eq(nil)
        end        

        it "supports lunch_hours" do
          expect(venue.lunch_hours).to eq("10:30 AM to Park Close")
        end        

        it "supports dinner_hours" do
          expect(venue.dinner_hours).to eq(nil)
        end        

        it "supports house_specialties" do
          expect(venue.house_specialties).to eq("Rotisserie chicken and ribs; burgers (and vegetarian burgers); hot\r\ndogs; Greek salad; chicken, turkey, and vegetable sandwiches; chicken\r\nnuggets; chili-cheese dog; barbecue-pork sandwich; chicken-noodle\r\nsoup; chili-cheese fries; gelato and cake for dessert. Kosher choices available\r\nby request.")
        end        

        it "supports counter_quality_rating" do
          expect(venue.counter_quality_rating).to eq("Good")
        end        

        it "supports counter_value_rating" do
          expect(venue.counter_value_rating).to eq("B")
        end        

        it "supports table_quality_rating" do
          expect(venue.table_quality_rating).to eq(nil)
        end        

        it "supports table_value_rating" do
          expect(venue.table_value_rating).to eq(nil)
        end        

        it "supports overall_rating" do
          expect(venue.overall_rating).to eq(nil)
        end        

        it "supports friendliness_rating" do
          expect(venue.friendliness_rating).to eq(nil)
        end        

        it "supports adult_breakfast_menu_url" do
          expect(venue.adult_breakfast_menu_url).to eq(nil)
        end        

        it "supports adult_lunch_menu_url" do
          expect(venue.adult_lunch_menu_url).to eq("http://allears.net/menu/men_cr.htm")
        end        

        it "supports adult_dinner_menu_url" do
          expect(venue.adult_dinner_menu_url).to eq("http://allears.net/menu/men_cr.htm")
        end        

        it "supports child_breakfast_menu_url" do
          expect(venue.child_breakfast_menu_url).to eq(nil)
        end        

        it "supports child_lunch_menu_url" do
          expect(venue.child_lunch_menu_url).to eq("http://allears.net/menu/men_cr.htm")
        end        

        it "supports child_dinner_menu_url" do
          expect(venue.child_dinner_menu_url).to eq("http://allears.net/menu/men_cr.htm")
        end        

        it "supports requires_credit_card" do
          expect(venue.requires_credit_card).to eq(false)
        end        

        it "supports requires_pre_payment" do
          expect(venue.requires_pre_payment).to eq(false)
        end        

        it "supports created_at" do
          expect(venue.created_at.class.to_s).to eq("DateTime")
        end        

        it "supports updated_at" do
          expect(venue.updated_at.class.to_s).to eq("DateTime")
        end        

        it "supports extinct_on" do
          expect(venue.extinct_on).to eq(nil)
        end        

        it "supports opened_on" do
          expect(venue.opened_on).to eq(nil)
        end        

        it "supports disney_permalink" do
          expect(venue.disney_permalink).to eq(nil)
        end        

        it "supports code" do
          expect(venue.code).to eq("ORL031")
        end        

        it "supports short_name" do
          expect(venue.short_name).to eq("Cosmic Ray's")
        end        

        it "supports accepts_reservations" do
          expect(venue.accepts_reservations).to eq(false)
        end        

        it "supports kosher_available" do
          expect(venue.kosher_available).to eq(true)
        end
      end

      context "table service with a short_name" do
        venue = Touringplans.show("magic kingdom","dining", "cinderellas_royal_table")

        it "supports  name" do
          expect(venue.name).to eq("Cinderella's Royal Table")
        end        

        it "supports showing the venue permalink" do
          expect(venue.permalink).to eq("cinderellas-royal-table")
        end        

        it "supports showing  the venue category_code" do
          expect(venue.category_code).to eq("table_service")
        end        

        it "supports portion_size" do
          expect(venue.portion_size).to eq(nil)
        end   

        it "supports cost_code" do
          expect(venue.cost_code).to eq("expensive")
        end        

        it "supports cuisine" do
          expect(venue.cuisine).to eq("American")
        end        

        it "supports phone_number" do
          expect(venue.phone_number).to eq("407-939-3463")
        end        

        it "supports entree_range" do
          expect(venue.entree_range).to eq("Breakfast: Adult $42, Child $27 ◆ Lunch: Adult $62, Child $37 ◆ Dinner: Adult $62, Child $37" )
        end        

        it "supports when_to_go" do
          expect(venue.when_to_go).to eq("Early")
        end        

        it "supports parking" do
          expect(venue.parking).to eq("Magic Kingdom lot")
        end        

        it "supports bar" do
          expect(venue.bar).to eq("Limited selection available")
        end        

        it "supports wine_list" do
          expect(venue.wine_list).to eq("Champagnes and sparkling wines by the glass and bottle. ")
        end        

        it "supports dress" do
          expect(venue.dress).to eq("Casual")
        end        

        it "supports awards" do
          expect(venue.awards).to eq(nil)
        end        

        it "supports breakfast_hours" do
          expect(venue.breakfast_hours).to eq("8:00 AM to 10:15 AM")
        end        

        it "supports lunch_hours" do
          expect(venue.lunch_hours).to eq("11:40 AM to 2:50 PM")
        end        

        it "supports dinner_hours" do
          expect(venue.dinner_hours).to eq("4:00 PM to 10:20 PM")
        end        

        it "supports house_specialties" do
          expect(venue.house_specialties).to eq("<p>\r\nAll meals are fixed-price character affairs, and the\r\nkitchen is upping its game - at breakfast there's caramel apple-stuffed\r\nFrench toast; goat cheese quiche; poached lobster and shrimp topped\r\nwith a poached egg and hollandaise; beef tenderloin and cheese frittata;\r\nor a healthy plate with scrambled egg whites, hot 10-grain cereal, Greek\r\nyogurt, house-made granola, walnut-sunflower bread, and fresh fruit. At\r\nlunch you'll find fish of the day, braised short ribs with parsnip mashed\r\npotatoes, gnocchi or rice with seasonal vegetables, and pan-seared\r\nchicken with goat cheese polenta. Dinner fare may include slow-roasted\r\npork loin and flourless chocolate cake.\r\n</p>\r\n\r\n<p>Guest order from a limited menu. Seconds or additional items are usually allowed, but are left to the discretion of the server.</p>" )
        end        

        it "supports counter_quality_rating" do
          expect(venue.counter_quality_rating).to eq(nil)
        end        

        it "supports counter_value_rating" do
          expect(venue.counter_value_rating).to eq(nil)
        end        

        it "supports table_quality_rating" do
          expect(venue.table_quality_rating.class.to_s).to eq("Float")
        end        

        it "supports table_value_rating" do
          expect(venue.table_value_rating.class.to_s).to eq("Float")
        end        

        it "supports overall_rating" do
          expect(venue.overall_rating.class.to_s).to eq("Float")
        end        

        it "supports service_rating" do
          expect(venue.service_rating.class.to_s).to eq("Float")
        end        

        it "supports friendliness_rating" do
          expect(venue.friendliness_rating.class.to_s).to eq("Float")
        end        

        it "supports adult_breakfast_menu_url" do
          expect(venue.adult_breakfast_menu_url).to eq("http://allears.net/menu/menu_crb.htm")
        end        

        it "supports adult_lunch_menu_url" do
          expect(venue.adult_lunch_menu_url).to eq("http://allears.net/menu/menu_crl.htm")
        end        

        it "supports adult_dinner_menu_url" do
          expect(venue.adult_dinner_menu_url).to eq("http://allears.net/menu/menu_crd.htm")
        end        

        it "supports child_breakfast_menu_url" do
          expect(venue.child_breakfast_menu_url).to eq("http://allears.net/menu/menu_crb.htm")
        end        

        it "supports child_lunch_menu_url" do
          expect(venue.child_lunch_menu_url).to eq("http://allears.net/menu/menu_crl.htm")
        end        

        it "supports child_dinner_menu_url" do
          expect(venue.child_dinner_menu_url).to eq("http://allears.net/menu/menu_crd.htm")
        end        

        it "supports requires_credit_card" do
          expect(venue.requires_credit_card).to eq(true)
        end        

        it "supports requires_pre_payment" do
          expect(venue.requires_pre_payment).to eq(true)
        end        

        it "supports created_at" do
          expect(venue.created_at.class.to_s).to eq("DateTime")
        end        

        it "supports updated_at" do
          expect(venue.updated_at.class.to_s).to eq("DateTime")
        end        

        it "supports extinct_on" do
          expect(venue.extinct_on).to eq(nil)
        end        

        it "supports opened_on" do
          expect(venue.opened_on).to eq(nil)
        end        

        it "supports disney_permalink" do
          expect(venue.disney_permalink).to eq(nil)
        end        

        it "supports code" do
          expect(venue.code).to eq("ORL027")
        end        

        it "supports short_name" do
          expect(venue.short_name).to eq("Cinderella's Table")
        end        

        it "supports accepts_reservations" do
          expect(venue.accepts_reservations).to eq(true)
        end        

        it "supports kosher_available" do
          expect(venue.kosher_available).to eq(false)
        end

      end
    end

    # context "when showing the details for an attraction" do
    #   it "supports showing an attraction's details" do
    #     expect(Touringplans.show("magic kingdom","attractions", "Astro Orbiter").permalink).to eq("astro-orbiter")
    #   end
    # end

    context "when showing the details for a hotel" do
      it "supports showing a hotels details" do
        # https://touringplans.com/walt-disney-world/hotels/disneys-grand-floridian-resort.json
        expect(Touringplans.show("walt disney world","hotels", "disneys-polynesian-resort").name).to eq("Disney's Polynesian Village Resort")
      end      
    end
    
  end

  describe "#update_route_table" do
    it "creates a yaml file name route_table.yml" do
      
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
      expect(Touringplans.list_all("attractions").length).to eq(166)
    end

    it "list all of the hotels at Walt Disney World" do
      expect(Touringplans.list_all("hotels").length).to eq(38)
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

  describe "#_assemble_route" do
    it "supports creating a route name for an attraction" do
      collection      = "magic kingdom" 
      interest_type   = "attractions"
      venue           = "casey jr splash n soak station"
      expect(Touringplans._assemble_route(collection, interest_type, venue)).to eq("magic_kingdom_attractions_casey_jr_splash_n_soak_station")
    end

    it "supports creating a route name for a hotel" do
      collection      = "walt disney world" 
      interest_type   = "hotels"
      venue           = "disneys polynesian village resort"
      expect(Touringplans._assemble_route(collection, interest_type, venue)).to eq("walt_disney_world_hotels_disneys_polynesian_village_resort")# "magic_kingdom_dining_caseys_corner")
    end

    it "supports creating a route name for a dining venue" do
      collection      = "magic kingdom" 
      interest_type   = "dining"
      venue           = "caseys corner"
      expect(Touringplans._assemble_route(collection, interest_type, venue)).to eq("magic_kingdom_dining_caseys_corner")
    end

    it "supports creating a route name for a list of attractions" do
      collection      = "magic kingdom" 
      interest_type   = "attractions"
      venue           = "list"
      expect(Touringplans._assemble_route(collection, interest_type, venue)).to eq("magic_kingdom_attractions")
    end

  end
    
end
