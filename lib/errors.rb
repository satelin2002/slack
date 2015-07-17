module Errors
  class InvalidRequestError < StandardError
    def initialize(message)
      super(message)
    end
  end

  class InvalidParameterError < StandardError

    attr_accessor :errors

    def initialize(message)
      @errors = {}
      super(message)
    end

    def add_error(param, error)
      @errors[param] ||= []
      @errors[param] << error
    end
  end

  INTERNAL_SERVER_ERROR_MSG = "The request failed due to an internal error."
  REQUEST_INVALID_ERROR_MSG = "The request input is invalid."
  FETCH_ERROR_MSG           = "Error fetching URL."
  PARAM_INVALID_ERROR_MSG   = "Parameter is not valid."
  PARAM_EMPTY_ERROR_MSG     = "Parameter is empty."
  INVALID_PAGE_ERROR_MSG    = "Invalid page content."
end