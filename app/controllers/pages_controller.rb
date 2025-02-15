require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def loading
  end

  def generate
    # call iata code for origin and destination from location param in trip
    # pass iata code into api
    @trip = Trip.find(params[:trip_id])
    @data = {
      flights: find_flight,
      accomms: find_accomms,
      activities: {
        restaurants: find_restaurants,
        attractions: find_attractions
      }
    }
    session[:trip_data] = @data
    # raise
    unless @data
      flash[:alert] = 'Flight not found'
    end
    sleep(6)
    redirect_to new_trip_flight_path(@trip)
  end

  def dashboard
    @user = current_user
    @trip = Trip.where(user: current_user).where("start_date > ?", Date.today).sort_by { |trip| trip.start_date}.first
  end

  def profile
  end

  def activities
  end

  def flip_card_back
  end

  private

  def find_flight
    # url = URI("https://skyscanner50.p.rapidapi.com/api/v1/searchFlights?origin=LHR&destination=SIN&date=2022-09-30&returnDate=2022-10-30&adults=1&currency=USD&countryCode=US&market=en-US")

    # http = Net::HTTP.new(url.host, url.port)
    # http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # request = Net::HTTP::Get.new(url)
    # request["X-RapidAPI-Key"] = 'f74f82968cmsh0a2149632e17456p1eaf7djsn1436ce748251'
    # request["X-RapidAPI-Host"] = 'skyscanner50.p.rapidapi.com'

    # response = http.request(request)
    # user_flights_data = response.read_body

    # user_flights_data_json = JSON.parse(user_flights_data)
    # user_flight_data_json = user_flights_data_json["data"].first(3)

    # user_flight_data_json = [{"id"=>"13554-2209301100--32080-1-16292-2210011040|16292-2210301930--32080-1-13554-2210310535", "price"=>{"amount"=>1844, "update_status"=>"current", "last_updated"=>"2022-09-04T02:04:00", "quote_age"=>45, "score"=>7.84173, "transfer_type"=>"MANAGED"}, "legs"=>[{"id"=>"13554-2209301100--32080-1-16292-2210011040", "origin"=>{"id"=>13554, "entity_id"=>95565050, "alt_id"=>"SIN", "parent_id"=>4698, "parent_entity_id"=>27544008, "name"=>"Singapore Changi", "type"=>"Airport", "display_code"=>"SIN"}, "destination"=>{"id"=>16292, "entity_id"=>95673375, "alt_id"=>"LHR", "parent_id"=>7101, "parent_entity_id"=>27546111, "name"=>"London Heathrow", "type"=>"Airport", "display_code"=>"LHR"}, "departure"=>"2022-09-20T21:50:00", "arrival"=>"2022-09-21T09:10:00", "duration"=>1000, "carriers"=>[{"id"=>-32080, "name"=>"Malaysia Airlines", "alt_id"=>"MH", "display_code"=>"MH", "display_code_type"=>"IATA", "alliance"=>-32000}], "stop_count"=>1, "stops"=>[{"id"=>13311, "entity_id"=>95673456, "alt_id"=>"KUL", "parent_id"=>4350, "parent_entity_id"=>27543923, "name"=>"Kuala Lumpur International", "type"=>"Airport", "display_code"=>"KUL"}]}, {"id"=>"16292-2210301930--32080-1-13554-2210310535", "origin"=>{"id"=>16292, "entity_id"=>95673375, "alt_id"=>"LHR", "parent_id"=>7101, "parent_entity_id"=>27546111, "name"=>"London Heathrow", "type"=>"Airport", "display_code"=>"LHR"}, "destination"=>{"id"=>13554, "entity_id"=>95565050, "alt_id"=>"SIN", "parent_id"=>4698, "parent_entity_id"=>27544008, "name"=>"Singapore Changi", "type"=>"Airport", "display_code"=>"SIN"}, "departure"=>"2022-09-30T18:10:00", "arrival"=>"2022-10-01T18:55:00", "duration"=>1085, "carriers"=>[{"id"=>-32080, "name"=>"Malaysia Airlines", "alt_id"=>"MH", "display_code"=>"MH", "display_code_type"=>"IATA", "alliance"=>-32000}], "stop_count"=>1, "stops"=>[{"id"=>13311, "entity_id"=>95673456, "alt_id"=>"KUL", "parent_id"=>4350, "parent_entity_id"=>27543923, "name"=>"Kuala Lumpur International", "type"=>"Airport", "display_code"=>"KUL"}]}], "is_eco_contender"=>true, "eco_contender_delta"=>19.061201, "score"=>7.82998, "totalDuration"=>2085}, {"id"=>"13554-2209302130--31821-1-16292-2210021855|16292-2210301950--31821-1-13554-2210311910", "price"=>{"amount"=>2301, "update_status"=>"current", "last_updated"=>"2022-09-04T02:04:00", "quote_age"=>45, "score"=>3.65474, "transfer_type"=>"MANAGED"}, "legs"=>[{"id"=>"13554-2209302130--31821-1-16292-2210021855", "origin"=>{"id"=>13554, "entity_id"=>95565050, "alt_id"=>"SIN", "parent_id"=>4698, "parent_entity_id"=>27544008, "name"=>"Singapore Changi", "type"=>"Airport", "display_code"=>"SIN"}, "destination"=>{"id"=>16292, "entity_id"=>95673375, "alt_id"=>"LHR", "parent_id"=>7101, "parent_entity_id"=>27546111, "name"=>"London Heathrow", "type"=>"Airport", "display_code"=>"LHR"}, "departure"=>"2022-09-20T00:50:00", "arrival"=>"2022-09-21T12:25:00", "duration"=>2305, "carriers"=>[{"id"=>-31821, "name"=>"SriLankan Airlines", "alt_id"=>"UL", "display_code"=>"UL", "display_code_type"=>"IATA", "alliance"=>-32000}], "stop_count"=>1, "stops"=>[{"id"=>10610, "entity_id"=>95673656, "alt_id"=>"CMB", "parent_id"=>1714, "parent_entity_id"=>27539843, "name"=>"Colombo Bandaranayake", "type"=>"Airport", "display_code"=>"CMB"}]}, {"id"=>"16292-2210301950--31821-1-13554-2210311910", "origin"=>{"id"=>16292, "entity_id"=>95673375, "alt_id"=>"LHR", "parent_id"=>7101, "parent_entity_id"=>27546111, "name"=>"London Heathrow", "type"=>"Airport", "display_code"=>"LHR"}, "destination"=>{"id"=>13554, "entity_id"=>95565050, "alt_id"=>"SIN", "parent_id"=>4698, "parent_entity_id"=>27544008, "name"=>"Singapore Changi", "type"=>"Airport", "display_code"=>"SIN"}, "departure"=>"2022-09-30T22:00:00", "arrival"=>"2022-10-01T21:25:00", "duration"=>1880, "carriers"=>[{"id"=>-31821, "name"=>"SriLankan Airlines", "alt_id"=>"UL", "display_code"=>"UL", "display_code_type"=>"IATA", "alliance"=>-32000}], "stop_count"=>1, "stops"=>[{"id"=>10610, "entity_id"=>95673656, "alt_id"=>"CMB", "parent_id"=>1714, "parent_entity_id"=>27539843, "name"=>"Colombo Bandaranayake", "type"=>"Airport", "display_code"=>"CMB"}]}], "is_eco_contender"=>false, "eco_contender_delta"=>0.7343888, "score"=>3.64927, "totalDuration"=>4185}, {"id"=>"13554-2209300645--32480,-31821-3-16292-2210011410|16292-2210302340--32611,-32080-1-13554-2210311525", "price"=>{"amount"=>1329, "update_status"=>"pending", "last_updated"=>"2022-09-04T02:31:27", "quote_age"=>18, "score"=>4.72576, "transfer_type"=>"PROTECTED_SELF_TRANSFER"}, "legs"=>[{"id"=>"13554-2209300645--32480,-31821-3-16292-2210011410", "origin"=>{"id"=>13554, "entity_id"=>95565050, "alt_id"=>"SIN", "parent_id"=>4698, "parent_entity_id"=>27544008, "name"=>"Singapore Changi", "type"=>"Airport", "display_code"=>"SIN"}, "destination"=>{"id"=>16292, "entity_id"=>95673375, "alt_id"=>"LHR", "parent_id"=>7101, "parent_entity_id"=>27546111, "name"=>"London Heathrow", "type"=>"Airport", "display_code"=>"LHR"}, "departure"=>"2022-09-20T17:15:00", "arrival"=>"2022-09-21T05:55:00", "duration"=>1465, "carriers"=>[{"id"=>-32480, "name"=>"British Airways", "alt_id"=>"BA", "display_code"=>"BA", "display_code_type"=>"IATA", "alliance"=>-32000}, {"id"=>-31821, "name"=>"SriLankan Airlines", "alt_id"=>"UL", "display_code"=>"UL", "display_code_type"=>"IATA", "alliance"=>-32000}], "stop_count"=>3, "stops"=>[{"id"=>12015, "entity_id"=>95674055, "alt_id"=>"GVA", "parent_id"=>2835, "parent_entity_id"=>33735985, "name"=>"Geneva", "type"=>"Airport", "display_code"=>"GVA"}, {"id"=>9618, "entity_id"=>95673509, "alt_id"=>"AUH", "parent_id"=>676, "parent_entity_id"=>27548192, "name"=>"Abu Dhabi International", "type"=>"Airport", "display_code"=>"AUH"}, {"id"=>10610, "entity_id"=>95673656, "alt_id"=>"CMB", "parent_id"=>1714, "parent_entity_id"=>27539843, "name"=>"Colombo Bandaranayake", "type"=>"Airport", "display_code"=>"CMB"}]}, {"id"=>"16292-2210302340--32611,-32080-1-13554-2210311525", "origin"=>{"id"=>16292, "entity_id"=>95673375, "alt_id"=>"LHR", "parent_id"=>7101, "parent_entity_id"=>27546111, "name"=>"London Heathrow", "type"=>"Airport", "display_code"=>"LHR"}, "destination"=>{"id"=>13554, "entity_id"=>95565050, "alt_id"=>"SIN", "parent_id"=>4698, "parent_entity_id"=>27544008, "name"=>"Singapore Changi", "type"=>"Airport", "display_code"=>"SIN"}, "departure"=>"2022-09-30T10:25:00", "arrival"=>"2022-10-01T10:20:00", "duration"=>1425, "carriers"=>[{"id"=>-32611, "name"=>"AirAsia", "alt_id"=>"AK", "display_code"=>"AK", "display_code_type"=>"IATA", "brand"=>-31992}, {"id"=>-32080, "name"=>"Malaysia Airlines", "alt_id"=>"MH", "display_code"=>"MH", "display_code_type"=>"IATA", "alliance"=>-32000}], "stop_count"=>1, "stops"=>[{"id"=>13311, "entity_id"=>95673456, "alt_id"=>"KUL", "parent_id"=>4350, "parent_entity_id"=>27543923, "name"=>"Kuala Lumpur International", "type"=>"Airport", "display_code"=>"KUL"}]}], "is_eco_contender"=>false, "eco_contender_delta"=>0, "score"=>4.71868, "totalDuration"=>2890}]

    user_flight_data_json = [{"id"=>"16292-2210281800--31939-1-13554-2210290615|13554-2211251415--31939-1-16292-2211261455", "price"=>{"amount"=>1137.12, "update_status"=>"current", "last_updated"=>"2022-10-26T11:39:00", "quote_age"=>1, "score"=>5.44837, "transfer_type"=>"MANAGED"}, "legs"=>[{"id"=>"16292-2210281800--31939-1-13554-2210290615", "origin"=>{"id"=>16292, "entity_id"=>95673375, "alt_id"=>"SINS", "parent_id"=>7101, "parent_entity_id"=>27546111, "name"=>"Singapore Changi", "type"=>"Airport", "display_code"=>"SIN"}, "destination"=>{"id"=>13554, "entity_id"=>95565050, "alt_id"=>"LHR", "parent_id"=>4698, "parent_entity_id"=>27544008, "name"=>"London Heathrow", "type"=>"Airport", "display_code"=>"LHR"}, "departure"=>"2022-10-28T18:00:00", "arrival"=>"2022-10-29T06:15:00", "duration"=>1155, "carriers"=>[{"id"=>-31939, "name"=>"Qatar Airways", "alt_id"=>"QR", "display_code"=>"QR", "display_code_type"=>"IATA", "alliance"=>-32000}], "stop_count"=>1, "stops"=>[{"id"=>11089, "entity_id"=>95673852, "alt_id"=>"DOH", "parent_id"=>2214, "parent_entity_id"=>27540785, "name"=>"Hamad International", "type"=>"Airport", "display_code"=>"DOH"}]}, {"id"=>"13554-2211251415--31939-1-16292-2211261455", "origin"=>{"id"=>13554, "entity_id"=>95565050, "alt_id"=>"LHR", "parent_id"=>4698, "parent_entity_id"=>27544008, "name"=>"London Heathrow", "type"=>"Airport", "display_code"=>"LHR"}, "destination"=>{"id"=>16292, "entity_id"=>95673375, "alt_id"=>"SIN", "parent_id"=>7101, "parent_entity_id"=>27546111, "name"=>"Singapore Changi", "type"=>"Airport", "display_code"=>"SIN"}, "departure"=>"2022-11-25T14:15:00", "arrival"=>"2022-11-26T14:55:00", "duration"=>1000, "carriers"=>[{"id"=>-31939, "name"=>"Qatar Airways", "alt_id"=>"QR", "display_code"=>"QR", "display_code_type"=>"IATA", "alliance"=>-32000}], "stop_count"=>1, "stops"=>[{"id"=>11089, "entity_id"=>95673852, "alt_id"=>"DOH", "parent_id"=>2214, "parent_entity_id"=>27540785, "name"=>"Hamad International", "type"=>"Airport", "display_code"=>"DOH"}]}], "is_eco_contender"=>false, "eco_contender_delta"=>-4.4089556, "score"=>5.44021, "totalDuration"=>2155}, {"id"=>"16292-2210282325--32090-1-13554-2210290815|13554-2211250600--31799-1-16292-2211261800", "price"=>{"amount"=>995.5, "update_status"=>"current", "last_updated"=>"2022-10-26T11:39:00", "quote_age"=>1, "score"=>5.09996, "transfer_type"=>"MANAGED"}, "legs"=>[{"id"=>"16292-2210282325--32090-1-13554-2210290815", "origin"=>{"id"=>16292, "entity_id"=>95673375, "alt_id"=>"SIN", "parent_id"=>7101, "parent_entity_id"=>27546111, "name"=>"Singapore Changi", "type"=>"Airport", "display_code"=>"SIN"}, "destination"=>{"id"=>13554, "entity_id"=>95565050, "alt_id"=>"LHR", "parent_id"=>4698, "parent_entity_id"=>27544008, "name"=>"London Heathrow", "type"=>"Airport", "display_code"=>"LHR"}, "departure"=>"2022-10-28T23:25:00", "arrival"=>"2022-10-29T08:15:00", "duration"=>950, "carriers"=>[{"id"=>-32090, "name"=>"Lufthansa", "alt_id"=>"LH", "display_code"=>"LH", "display_code_type"=>"IATA", "alliance"=>-31999}], "stop_count"=>1, "stops"=>[{"id"=>14385, "entity_id"=>95673491, "alt_id"=>"MUC", "parent_id"=>5363, "parent_entity_id"=>27545034, "name"=>"Munich", "type"=>"Airport", "display_code"=>"MUC"}]}, {"id"=>"13554-2211250600--31799-1-16292-2211261800", "origin"=>{"id"=>13554, "entity_id"=>95565050, "alt_id"=>"LHR", "parent_id"=>4698, "parent_entity_id"=>27544008, "name"=>"London Heathrow", "type"=>"Airport", "display_code"=>"LHR"}, "destination"=>{"id"=>16292, "entity_id"=>95673375, "alt_id"=>"SIN", "parent_id"=>7101, "parent_entity_id"=>27546111, "name"=>"Singapore Changi", "type"=>"Airport", "display_code"=>"SIN"}, "departure"=>"2022-11-25T06:00:00", "arrival"=>"2022-11-26T18:00:00", "duration"=>1680, "carriers"=>[{"id"=>-31799, "name"=>"SWISS", "alt_id"=>"LX", "display_code"=>"LX", "display_code_type"=>"IATA", "alliance"=>-31999}], "stop_count"=>1, "stops"=>[{"id"=>18563, "entity_id"=>95673856, "alt_id"=>"ZRH", "parent_id"=>9168, "parent_entity_id"=>27537524, "name"=>"Zurich", "type"=>"Airport", "display_code"=>"ZRH"}]}], "is_eco_contender"=>true, "eco_contender_delta"=>14.584893, "score"=>5.09232, "totalDuration"=>2630}, {"id"=>"16292-2210281800--32480-1-13554-2210290615|13554-2211251855--31939-1-16292-2211262115", "price"=>{"amount"=>1016.6, "update_status"=>"current", "last_updated"=>"2022-10-26T11:39:00", "quote_age"=>1, "score"=>5.82403, "transfer_type"=>"MANAGED"}, "legs"=>[{"id"=>"16292-2210281800--32480-1-13554-2210290615", "origin"=>{"id"=>16292, "entity_id"=>95673375, "alt_id"=>"SIN", "parent_id"=>7101, "parent_entity_id"=>27546111, "name"=>"Singapore Changi", "type"=>"Airport", "display_code"=>"SIN"}, "destination"=>{"id"=>13554, "entity_id"=>95565050, "alt_id"=>"LHR", "parent_id"=>4698, "parent_entity_id"=>27544008, "name"=>"London Heathrow", "type"=>"Airport", "display_code"=>"LHR"}, "departure"=>"2022-10-28T18:00:00", "arrival"=>"2022-10-29T06:15:00", "duration"=>1155, "carriers"=>[{"id"=>-32480, "name"=>"British Airways", "alt_id"=>"BA", "display_code"=>"BA", "display_code_type"=>"IATA", "alliance"=>-32000}], "stop_count"=>1, "stops"=>[{"id"=>11089, "entity_id"=>95673852, "alt_id"=>"DOH", "parent_id"=>2214, "parent_entity_id"=>27540785, "name"=>"Hamad International", "type"=>"Airport", "display_code"=>"DOH"}]}, {"id"=>"13554-2211251855--31939-1-16292-2211262115", "origin"=>{"id"=>13554, "entity_id"=>95565050, "alt_id"=>"LHR", "parent_id"=>4698, "parent_entity_id"=>27544008, "name"=>"London Heathrow", "type"=>"Airport", "display_code"=>"LHR"}, "destination"=>{"id"=>16292, "entity_id"=>95673375, "alt_id"=>"SIN", "parent_id"=>7101, "parent_entity_id"=>27546111, "name"=>"Singapore Changi", "type"=>"Airport", "display_code"=>"SIN"}, "departure"=>"2022-11-25T18:55:00", "arrival"=>"2022-11-26T21:15:00", "duration"=>1100, "carriers"=>[{"id"=>-31939, "name"=>"Qatar Airways", "alt_id"=>"QR", "display_code"=>"QR", "display_code_type"=>"IATA", "alliance"=>-32000}], "stop_count"=>1, "stops"=>[{"id"=>11089, "entity_id"=>95673852, "alt_id"=>"DOH", "parent_id"=>2214, "parent_entity_id"=>27540785, "name"=>"Hamad International", "type"=>"Airport", "display_code"=>"DOH"}]}], "is_eco_contender"=>false, "eco_contender_delta"=>1.0347903, "score"=>5.81531, "totalDuration"=>2255}]

    flight_array = []
    user_flight_data_json.each do |flight|
      flight_array << {
                      amount: flight["price"]["amount"],
                      outbound_origin_display_code: flight["legs"][0]["origin"]["display_code"],
                      outbound_destination_display_code: flight["legs"][0]["destination"]["display_code"],
                      outbound_departure: flight["legs"][0]["departure"],
                      outbound_arrival: flight["legs"][0]["arrival"],
                      outbound_carrier_name: flight["legs"][0]["carriers"][0]["name"],
                      inbound_origin_display_code: flight["legs"][1]["origin"]["display_code"],
                      inbound_destination_display_code: flight["legs"][1]["destination"]["display_code"],
                      inbound_departure: flight["legs"][1]["departure"],
                      inbound_arrival: flight["legs"][1]["arrival"],
                      inbound_carrier_name: flight["legs"][1]["carriers"][0]["name"],
                      api_flight_id: flight["id"]
                    }
    end
    flight_array
  end

  def find_accomms


    # # search place for API for under entityId
    # url = URI("https://skyscanner50.p.rapidapi.com/api/v1/searchPlace?query=london")

    # http = Net::HTTP.new(url.host, url.port)
    # http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # request = Net::HTTP::Get.new(url)
    # request["X-RapidAPI-Key"] = '75b3c86115mshb9bee2c7b8ee1d8p1732dajsn9c61acf70f92'
    # request["X-RapidAPI-Host"] = 'skyscanner50.p.rapidapi.com'

    # response = http.request(request)
    # user_accommodations_data = response.read_body

    # user_accommodations_data_json = JSON.parse(user_accommodations_data)


    # accommodations = user_accommodations_data_json["data"].first(3)

    # entity_ids = []
    # accommodations.each do |accommodation|
    #   entity_ids << accommodation["entityId"]
    # end

    # entity_ids

    # accoms_array = []

    # entity_ids.each do |entity_id|
    #   url = URI("https://skyscanner50.p.rapidapi.com/api/v1/searchHotel?entityId=#{entity_id}&checkin=2022-09-30&checkout=2022-10-30&waitTime=2000&currency=USD&countryCode=US&market=en-US")

    #   http = Net::HTTP.new(url.host, url.port)
    #   http.use_ssl = true
    #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    #   request = Net::HTTP::Get.new(url)
    #   request["X-RapidAPI-Key"] = '75b3c86115mshb9bee2c7b8ee1d8p1732dajsn9c61acf70f92'
    #   request["X-RapidAPI-Host"] = 'skyscanner50.p.rapidapi.com'

    #   response = http.request(request)
    #   user_accommodations_v2_data = response.read_body

    #   user_accommodations_v2_data_json = JSON.parse(user_accommodations_v2_data)
    #   accoms_array << user_accommodations_v2_data_json
    # end

    # accoms = []

    # accoms_array do |accom|
    #   accoms << {
    #               entity_id:
    #               hotel_id:
    #               name:
    #               price:
    #               latitude:
    #               longitude:
    #               cheapest_partner:
    #               stars:
    #               hero_image:
    #               value:
    #               description:
    #             }
    # end

    #url = URI("https://skyscanner50.p.rapidapi.com/api/v1/searchHotel?entityId=27544008&checkin=2022-09-30&checkout=2022-10-30&waitTime=2000&currency=USD&countryCode=US&market=en-US")

    # search place API to get entity ID
    # url = URI("https://skyscanner50.p.rapidapi.com/api/v1/searchPlace?query=london")


    # http = Net::HTTP.new(url.host, url.port)
    # http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # request = Net::HTTP::Get.new(url)
    # request["X-RapidAPI-Key"] = 'ac49dd4730msh08ae8f552f388afp1aadd1jsn9b400b1d9b91'
    # request["X-RapidAPI-Host"] = 'skyscanner50.p.rapidapi.com'

    # response = http.request(request)
    # user_place_data = response.read_body
    # user_place_data_json = JSON.parse(user_place_data)
    # user_place_data_json = user_place_data_json["data"].first
    # entityid = ?

    # search hotel API
    # url = URI("https://skyscanner50.p.rapidapi.com/api/v1/searchHotel?entityId=%3CREQUIRED%3E&checkin=%3CREQUIRED%3E&checkout=%3CREQUIRED%3E&waitTime=2000&currency=USD&countryCode=US&market=en-US")

    # http = Net::HTTP.new(url.host, url.port)
    # http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # request = Net::HTTP::Get.new(url)
    # request["X-RapidAPI-Key"] = 'ac49dd4730msh08ae8f552f388afp1aadd1jsn9b400b1d9b91'
    # request["X-RapidAPI-Host"] = 'skyscanner50.p.rapidapi.com'

    # response = http.request(request)
    # user_accomms_data = response.read_body
    # user_accomms_data_json = JSON.parse(user_accomms_data)
    # user_accomms_data = user_accomms_data_json["data"].first


    # user_accommodation_data_json = {}
    #user_accomms_data = {

    #  entity_id: ,
    #  hotel_id: ,
    #  name: ,
    #  price: ,
    #  latitude: ,
    #  longitude: ,
    #  cheapest_partner: ,
    #  stars: ,
    #  hero_image: ,
    #  value: ,
    #  description: ,
    # }

    # user_accomms_data = {
    # entity_id: ,
    # hotel_id: ,
    # name: ,
    # price: ,
    # latitude: ,
    # longitude: ,
    # cheapest_partner: ,
    # stars: ,
    # hero_image: ,
    # value: ,
    # description: ,
    # }
  end

  def find_restaurants
  end

  def find_attractions
  end
end
