require 'open-uri'
require 'nokogiri'
require 'cgi'

class Document

  attr_reader :doc
  attr_reader :source

  def initialize(url)
    @url = url
    begin
      @source = open(url).read
      @doc = Nokogiri::HTML(@source)
    rescue
      raise Errors::FETCH_ERROR_MSG
    end
  end

  def tag_count
    tag_names.delete("html")
    tag_names.each_with_object({}) { |n, r| r[n] = (r[n] || 0) + 1 }
  end

  def tag_names
    @doc.xpath("//*").map(&:name)
  end

end