class ReviewJob < ApplicationJob
  queue_as :default
  require 'net/http'
  require 'nokogiri'
  require 'open-uri'

  def perform
    rooms = Room.all
    begin
      rooms.each do |room|
        offset = 50
        response_reviews = api_call room
        total_count = response_reviews["metadata"]["reviewsCount"].to_i
        reviews_array = response_reviews["reviews"]
        if total_count > offset
          n_times = (total_count / offset).floor
          n_times.times do
            response = api_call room, offset
            reviews_array += response["reviews"]
            offset +=50
          end
        end
        create_review reviews_array, room
      end
    rescue => exception
      exception.message
    end
  end

  def api_call room, offset = 0
    room_url = room.link.strip
    unless room_url.scan(/(?<=\/rooms\/).[0-9]+/).present?
      doc = Nokogiri::HTML(URI.open(room_url))
      content = doc.search("meta[property='og:url']").map { |n| n['content']}
      room_url = content.first.strip
    end
    room_id = room_url.scan(/(?<=\/rooms\/).[0-9]+/)
    raise StandardError.new "Invalid URL" unless room_id.present?

    doc = Nokogiri::HTML(URI.open("https://www.airbnb.com/rooms/#{room_id.first}"))
    token = JSON.parse(doc.search('#data-state').text)["bootstrapData"]["layout-init"]["api_config"]["key"]
    url = URI("https://www.airbnb.com/api/v3/PdpReviews?operationName=PdpReviews&variables={\"request\":{\"fieldSelector\":\"for_p3_translation_only\",\"limit\":100,\"listingId\":\"#{room_id.first}\",\"offset\":\"#{offset}\",\"showingTranslationButton\":false,\"numberOfAdults\":\"1\",\"numberOfChildren\":\"0\",\"numberOfInfants\":\"0\"}}&extensions={\"persistedQuery\":{\"version\":1,\"sha256Hash\":\"6a71d7bc44d1f4f16cced238325ced8a93e08ea901270a3f242fd29ff02e8a3a\"}}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["X-Airbnb-API-Key"] = token
    request["cache-control"] = 'no-cache'

    response = http.request(request)
    body = JSON.parse(response.body)
    body["data"]["merlin"]["pdpReviews"]
  end

  def create_review response_reviews, room
    response_reviews.each do |review|
      room.reviews.create!(original_id: review["id"],
                           created: review["createdAt"],
                           rating: review["rating"],
                           area: :airbnb,
                           comment: review["comments"],
                           reviewer_name: review["reviewer"]["firstName"],
                           user_picture: review["reviewer"]["userProfilePicture"]["baseUrl"]
      ) unless room.reviews.exists?( original_id: review["id"] )
    end
  end
end
