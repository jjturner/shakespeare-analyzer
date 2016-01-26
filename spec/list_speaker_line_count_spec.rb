require './app/LineCounter.rb'
require 'nokogiri'

describe LineCounter do
  # start with desired end state
  it "lists hash of speakers by line count" do
    # setup
    xml = "<PLAY><SPEECH><SPEAKER>Bob</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH></PLAY>"
    line_counter = LineCounter.new(xml)

    # exercise
    character_lines = line_counter.count_lines_per_speech

    # verify
    expect(character_lines).to eq([ { "Bob" => 2 } ])
    
  end

  it "aggregates counts for each speech" do
    # setup
    xml = "<PLAY><SPEECH><SPEAKER>Bob</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH>"
    xml += "<SPEECH><SPEAKER>Bob</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH></PLAY>"
    line_counter = LineCounter.new(xml)
    input_array = [{"Bob"=>2}, {"Bob"=>2}] 

    # exercise
    character_lines = line_counter.sum_lines_by_speaker(input_array)

    # verify
    expect(character_lines).to eq({ "Bob" => 4 })
  end

  it "aggregates counts for each speech by each character" do
    # setup
    xml = "<PLAY><SPEECH><SPEAKER>Bob</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH>"
    xml += "<SPEECH><SPEAKER>Fred</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH>"
    xml += "<SPEECH><SPEAKER>Bob</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH></PLAY>"
    line_counter = LineCounter.new(xml)
    input_array = [{"Bob"=>2}, {"Fred"=>2},{"Bob"=>2}] 

    # exercise
    character_lines = line_counter.sum_lines_by_speaker(input_array)

    # verify
    expect(character_lines).to eq({"Bob"=>4, "Fred"=>2})
  end

  it "excludes the 'ALL' character designation" do
    # setup
    xml = "<PLAY><SPEECH><SPEAKER>Bob</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH>"
    xml += "<SPEECH><SPEAKER>Fred</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH>"
    xml += "<SPEECH><SPEAKER>ALL</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH>"
    xml += "<SPEECH><SPEAKER>Bob</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH></PLAY>"

    line_counter = LineCounter.new(xml)

    # exercise
    character_lines = line_counter.count_lines_per_speech

    # verify
    expect(character_lines).to eq([ {"Bob"=>2}, {"Fred"=>2},{"Bob"=>2} ])
  end

  it "outputs results by count, then character" do
    
    xml = "<PLAY><SPEECH><SPEAKER>Bob</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH>"
    xml += "<SPEECH><SPEAKER>Fred</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH>"
    xml += "<SPEECH><SPEAKER>Bob</SPEAKER>"
    xml += "<LINE>Hello</LINE><LINE>Bye</LINE></SPEECH></PLAY>"

    line_counter = LineCounter.new(xml)
    hash = {"Bob"=>4,"Fred"=>2}

    expect(line_counter.display(hash)).to eq("4 Bob\n2 Fred")
  end

  it "does not accept unformed xml from source" do
    expect{ LineCounter.new('foo') }.to raise_error(Nokogiri::XML::SyntaxError)
  end
end
