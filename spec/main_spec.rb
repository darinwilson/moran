describe "Moran" do

  it "can parse String values" do
    json = '{ my_dog: "has_fleas" }'
    hash = Moran.parse(json)
    hash["my_dog"].should == "has_fleas"
  end

  it "can parse Boolean values" do
    json = '{ my_dog_has_fleas: true }'
    hash = Moran.parse(json)
    hash["my_dog_has_fleas"].should == true
  end

  it "can parse Numeric values" do
    json = '{ flea_count: 12 }'
    hash = Moran.parse(json)
    hash["flea_count"].should == 12
  end

  it "can parse Array values" do
    json = '{ my_dog_has: ["fleas","bones","a loud bark"] }'
    hash = Moran.parse(json)

    # Now, you'd think this next line would work, right? It doesn't, even when the values
    # are the same. Life on the bleeding edge... :'(
    #hash["my_dog_has"].should == ["fleas","bones","a loud bark"]

    # So, we do it the hard way...
    arrays_are_equal?(hash["my_dog_has"], ["fleas","bones","a loud bark"]).should == true
  end

  it "can parse Hash values" do
    json = '{ dog: { name: "Rex", fleas: true } }'
    hash = Moran.parse(json)
    hash["dog"]["name"].should == "Rex"
    hash["dog"]["fleas"].should == true
  end

  it "can parse nested Hashes" do
    json = '{ dog: { name: "Rex", fleas: { count: 12, severity: "moderate" } } }'
    hash = Moran.parse(json)
    nested = hash["dog"]["fleas"]
    nested["count"].should == 12
    nested["severity"].should == "moderate"
  end

  it "can parse JSON that is just an array" do
    json = '[ "my", "dog", "has", "fleas" ]'
    array = Moran.parse(json)
    arrays_are_equal?(array, [ "my", "dog", "has", "fleas"]).should == true
  end

  it "can parse a large file in a reasonable amount of time" do
    start_time = Time.now
    hash = Moran.parse(LargeJson::JSON_STRING)
    end_time = Time.now
    (end_time - start_time).should.satisfy { |parse_time| parse_time < 1.0 }
  end

  it "can generate String values" do
    hash = { my_dog: "has fleas" }
    json = Moran.generate(hash)
    new_hash = Moran.parse(json)
    new_hash["my_dog"].should == "has fleas"
  end

  it "can generate Boolean values" do
    hash = { my_dog_has_fleas: true }
    json = Moran.generate(hash)
    new_hash = Moran.parse(json)
    new_hash["my_dog_has_fleas"].should == true
  end

  it "can generate Numeric values" do
    hash = { flea_count: 12 }
    json = Moran.generate(hash)
    new_hash = Moran.parse(json)
    new_hash["flea_count"].should == 12
  end

  it "can generate Array values" do
    ary = ["fleas","bones","a loud bark"]
    hash = { my_dog_has: ary }
    json = Moran.generate(hash)
    new_hash = Moran.parse(json)

    # this won't work - see comment in "can parse Array values"
    #new_hash["my_dog_has"].should == ["fleas","bones","a loud bark"]
    arrays_are_equal?(new_hash["my_dog_has"], ary).should == true
  end

  it "can generate Hash values" do
    hash = { dog: { name: "Rex", fleas: true } }
    json = Moran.generate(hash)
    new_hash = Moran.parse(json)
    new_hash["dog"]["name"].should == "Rex"
    new_hash["dog"]["fleas"].should == true
  end

  it "can generate nested Hashes" do
    hash = { dog: { name: "Rex", fleas: { count: 12, severity: "moderate" } } }
    json = Moran.generate(hash)
    new_hash = Moran.parse(json)
    nested = new_hash["dog"]["fleas"]
    nested["count"].should == 12
    nested["severity"].should == "moderate"
  end

  it "can generate a JSON Array" do
    array = [ "my", "dog", "has", "fleas" ]
    json = Moran.generate(array)
    new_array = Moran.parse(json)
    arrays_are_equal?(new_array, array).should == true
  end

  it "can add to_json to a Hash" do
    hash = { dog: { name: "Rex", fleas: { count: 12, severity: "moderate" } } }
    new_hash = Moran.parse(hash.to_json)
    nested = new_hash["dog"]["fleas"]
    nested["count"].should == 12
    nested["severity"].should == "moderate"
  end

  # this is mostly just a spot check - a deeper test of all types would be good to have
  it "can convert a JSONObject to a Hash" do
    json_obj = Org::Json::JSONObject.new
    json_obj.put("string", "dog")
    json_obj.put("boolean", true)
    ary = ["my", "dog", "has", "fleas"]
    json_obj.put("array", ary)
    json_obj.put("hashmap", RubyToJava.convert_hash({ "my_dog_has" => "fleas" }))

    hash = Hash.from_json_object(json_obj)
    hash["string"].should == "dog"
    hash["boolean"].should == true
    arrays_are_equal?(hash["array"], ary).should == true
    hash["hashmap"]["my_dog_has"].should == "fleas"
  end


  def arrays_are_equal?(arr1, arr2)
    return false unless arr1.length == arr2.length
    index = 0
    while (index < arr1.length)
      return false unless arr1[index] == arr2[index]
      index += 1
    end
    true
  end

end
