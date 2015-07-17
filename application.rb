require 'rubygems'
require 'bundler'
Bundler.setup

require 'net/http'
require 'uri'
require 'json'

require_relative "environment"
require_relative "lib/errors"
require_relative "lib/models/document"

class App < Sinatra::Base

  API_ERRORS = {
    internal_error:  {
      status_code: 500, message: Errors::INTERNAL_SERVER_ERROR_MSG },
    invalid_request: {
      status_code: 400, message: Errors::REQUEST_INVALID_ERROR_MSG },
  }

  error do
    raised_error = env["sinatra.error"]
    if raised_error
      case raised_error
      when Errors::InvalidRequestError
        show_error :invalid_request, raised_error.message
      when Errors::InvalidParameterError
        show_error :invalid_request, raised_error.message
      else
        show_error :internal_error, raised_error.message
      end
    end
  end

  def show_error(error_code, details = nil)
    error = API_ERRORS[error_code]
    response = { status: error_code, message: error[:message] }
    response[:details] = details unless details.nil?
    halt error[:status_code], response.to_json
  end

  get '/' do
    erb :index
  end

  before '/fetch' do
    content_type :json
    begin
      params = JSON.parse(request.env["rack.input"].read)
    rescue
      raise Errors::InvalidRequestError, Errors::REQUEST_INVALID_ERROR_MSG
    end
    if params.nil? || params["url"].nil? || params["url"].empty?
      raise Errors::InvalidParameterError, Errors::PARAM_EMPTY_ERROR_MSG
    end
    @url = params["url"]
    unless @url =~ URI::regexp
      raise Errors::InvalidParameterError, Errors::PARAM_INVALID_ERROR_MSG
    end
  end

  post '/fetch' do
    document = Document.new(@url)
    {
      url: @url,
      formatted: document.formatted,
      source: document.source,
      tagCount: document.tag_count
    }.to_json
  end

end
