require './app/LineCounter.rb'
require 'nokogiri'

describe LineCounter do
  # start with desired end state
  it "lists hash of speakers by line count" do
    # setup
    xml = "<PLAY><SPEECH><SPEAKER>Bob</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH></PLAY>"
    doc = Nokogiri::XML(xml)
    line_counter = LineCounter.new

    # exercise
    character_lines = line_counter.lines(doc)

    # verify
    expect(character_lines).to eq "2 Bob"
    
  end

  it "aggregates counts for each speech" do
    # setup
    xml = "<PLAY><SPEECH><SPEAKER>Bob</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH>"
    # xml += "<PLAY><SPEECH><SPEAKER>Fred</SPEAKER>"
    # xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH></PLAY>"
    xml += "<SPEECH><SPEAKER>Bob</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH></PLAY>"
    doc = Nokogiri::XML(xml)
    line_counter = LineCounter.new

    # exercise
    character_lines = line_counter.lines(doc)

    # verify
    expect(character_lines).to eq "4 Bob"
  end
end
