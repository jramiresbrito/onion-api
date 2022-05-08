module RequestAPI
  def json_body(symbolize_keys: false)
    json = JSON.parse(response.body)
    symbolize_keys ? json.deep_symbolize_keys : json
  rescue StandardError
    {}
  end

  def header(merge_with: {})
    header = { 'Content-type' => 'application/json', 'Accept' => 'application/json' }
    header.merge merge_with
  end
end

RSpec.configure do |config|
  config.include RequestAPI, type: :request
end
