require 'open-uri'
require 'nokogiri'
require 'cgi'
require 'sax-machine'

SAXMachine.handler = :nokogiri

class MyDocument < Nokogiri::XML::SAX::Document
  def start_element(name, attrs = [])
    #puts name
    #puts attr
  end
  def end_element(name)
    #puts name
  end
  def characters(string)
    #puts string
  end
  def comment(string)
    puts string
  end
  def warning(string)
  end
  def error(string)
  end
  def cdata_block(string)
  end
end



@url = "http://stackoverflow.com/questions/8728046/how-to-use-sax-with-nokogiri"
@source = open(@url ).read
parser = Nokogiri::HTML::SAX::Parser.new(MyDocument.new)
parser.parse(@source)
