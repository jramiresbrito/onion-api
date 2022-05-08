require 'spec_helper'

RSpec.describe "Starlinks", type: :request do
  describe "POST /nearby" do
    context 'valid requests' do
      let!(:lat) { rand(-90..90) }
      let!(:lon) { rand(-180..180) }
      let!(:amount) { rand(1..5) }

      context 'regular requests' do
        before do
          post '/starlink/nearby', params: { lat: lat, lon: lon, amount: amount }, as: :json
        end

        it 'returns proper response' do
          expect(json_body.size).to eq(amount)

          json_body.each do |record|
            expect(record.size).to eq(7)
            expect(record).to have_key("id")
            expect(record).to have_key("name")
            expect(record).to have_key("sat_lat")
            expect(record).to have_key("sat_lon")
            expect(record).to have_key("input_lat")
            expect(record).to have_key("input_lon")
            expect(record).to have_key("distance")
          end
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end
      end
    end

    context "invalid requests" do
      let!(:lat) { rand(-90..90) }
      let!(:lon) { rand(-180..180) }
      let!(:amount) { rand(1..5) }

      context 'when latitude is invalid' do
        context 'latitude is out of range' do
          before do
            post '/starlink/nearby', params: { lat: -91, lon: lon, amount: amount }, as: :json
          end

          it 'returns an error message' do
            expect(json_body).to have_key("errors")
            expect(json_body["errors"][0]["coordinate"]).to match("Provided coordinates are invalid. Please check your entry.")
          end

          it 'returns unprocessable_entity status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'latitude is not a number' do
          before do
            post '/starlink/nearby', params: { lat: "a", lon: lon, amount: amount }, as: :json
          end

          it 'returns an error message' do
            expect(json_body).to have_key("errors")
            expect(json_body["errors"][0]["coordinate"]).to match("Provided coordinates are invalid. Please check your entry.")
          end

          it 'returns unprocessable_entity status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'when latitude is nil' do
          before do
            post '/starlink/nearby', params: { lat: nil, lon: lon, amount: amount }, as: :json
          end

          it 'returns an error message' do
            expect(json_body).to have_key("errors")
            expect(json_body["errors"][0]["coordinate"]).to match("Provided coordinates are invalid. Please check your entry.")
          end

          it 'returns unprocessable_entity status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end

      context 'when longitude is invalid' do
        context 'longitude is out of range' do
          before do
            post '/starlink/nearby', params: { lat: lat, lon: 181, amount: amount }, as: :json
          end

          it 'returns an error message' do
            expect(json_body).to have_key("errors")
            expect(json_body["errors"][0]["coordinate"]).to match("Provided coordinates are invalid. Please check your entry.")
          end

          it 'returns unprocessable_entity status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'longitude is not a number' do
          before do
            post '/starlink/nearby', params: { lat: lat, lon: "b", amount: amount }, as: :json
          end

          it 'returns an error message' do
            expect(json_body).to have_key("errors")
            expect(json_body["errors"][0]["coordinate"]).to match("Provided coordinates are invalid. Please check your entry.")
          end

          it 'returns unprocessable_entity status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'when longitude is nil' do
          before do
            post '/starlink/nearby', params: { lat: lat, lon: nil, amount: amount }, as: :json
          end

          it 'returns an error message' do
            expect(json_body).to have_key("errors")
            expect(json_body["errors"][0]["coordinate"]).to match("Provided coordinates are invalid. Please check your entry.")
          end

          it 'returns unprocessable_entity status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end

      context 'when amount is invalid' do
        context 'amount is not a number' do
          before do
            post '/starlink/nearby', params: { lat: lat, lon: lon, amount: "c" }, as: :json
          end

          it 'returns an error message' do
            expect(json_body).to have_key("errors")
            expect(json_body["errors"][0]["amount"]).to match("Amount is invalid. Please provide a positive integer")
          end

          it 'returns unprocessable_entity status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'when amount is nil' do
          before do
            post '/starlink/nearby', params: { lat: lat, lon: lon, amount: nil }, as: :json
          end

          it 'returns an error message' do
            expect(json_body).to have_key("errors")
            expect(json_body["errors"][0]["amount"]).to match("Amount is invalid. Please provide a positive integer")
          end

          it 'returns unprocessable_entity status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
  end
end
