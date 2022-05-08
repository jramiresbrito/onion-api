class StarlinksController < ApplicationController
  class InvalidAmountError < StandardError; end
  class InvalidCoordinatesError < StandardError; end

  before_action :validate_coordinates, only: :nearby

  def nearby
    query = default_near_query(starlink_params)

    response = SpacexApi.client.query_starlinks(query.to_json)

    satellites = find_nearest_satellites(response)

    render json: satellites
  end

  private

  def starlink_params
    params.permit(:lat, :lon, :amount)
  end

  def invalid_amount
    render json: {
      errors: [{
        amount: 'Amount is invalid. Please provide a positive integer'
      }]
    }, status: :unprocessable_entity
  end

  def invalid_coordinates
    render json: {
      errors: [{
        coordinate: 'Provided coordinates are invalid. Please check your entry.'
      }]
    }, status: :unprocessable_entity
  end

  def validate_coordinates
    latitude = params[:lat]
    longitude = params[:lon]
    amount = params[:amount]

    raise InvalidAmountError unless (amount.present? && amount.is_a?(Numeric))
    raise InvalidCoordinatesError unless (latitude.present? && longitude.present?)
    raise InvalidCoordinatesError unless (latitude.is_a?(Numeric) && longitude.is_a?(Numeric))
    raise InvalidCoordinatesError unless (latitude.to_f.between?(-90, 90) && longitude.to_f.between?(-180, 180))
  rescue InvalidAmountError
    invalid_amount
  rescue InvalidCoordinatesError
    invalid_coordinates
  end

  def default_near_query(params)
    {
      query: {
        latitude: {
          '$ne': nil
        }
      },
      options: {
        select: {
          id: 1,
          'spaceTrack.OBJECT_NAME': 1,
          latitude: 1,
          longitude: 1
        },
        limit: params[:amount],
        sort: {
          latitude: "desc"
        }
      }
    }
  end

  def find_nearest_satellites(response)
    satellites = response.docs.map do |sat|
      {
        id: sat.id,
        name: sat.spaceTrack.OBJECT_NAME,
        sat_lat: sat.latitude,
        sat_lon: sat.longitude,
        input_lat: params[:lat],
        input_lon: params[:lon],
        distance: Haversine.distance(
          params[:lat].to_f,
          params[:lon].to_f,
          sat.latitude.to_f,
          sat.longitude.to_f
        ).to_miles
      }
    end

    satellites.sort_by! { |sat| sat[:distance] }.take(params[:amount].to_i)
  end
end
