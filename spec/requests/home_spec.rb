require 'spec_helper'

describe '/home', type: :request do
  it 'should return { "ok" => true } for successful get requests' do
    get '/home', headers: header
    expect(json_body).to eq({ 'ok' => true })
  end

  it 'should return { ok: true } for successful get requests using symbolize_keys option' do
    get '/home', headers: header
    expect(json_body(symbolize_keys: true)).to eq({ ok: true })
  end

  it 'should have status 200: ok for successful get requests' do
    get '/home', headers: header
    expect(response).to have_http_status(200)
  end
end
