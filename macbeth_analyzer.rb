require './app/LineCounter'
require 'nokogiri'

source_xml = "http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml"
# source_xml = "./spec/fixtures/macbeth_local.rb"

generate_stats = LineCounter.new(source_xml, "html")
