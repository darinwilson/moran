class Moran

  module_function

  def parse(json)
    mapper = Com::Fasterxml::Jackson::Databind::ObjectMapper.new
    mapper.configure(Com::Fasterxml::Jackson::Core::JsonParser::Feature::ALLOW_UNQUOTED_FIELD_NAMES, 
                     true)
    java_hash = mapper.readValue(json, Hash)
    # we still don't have a completely smooth conversion of types between JavaLand and RubyLand,
    # so this next step seems to be necessary
    JavaToRuby.convert_hashmap(java_hash)
  end

  def generate(hash)
    mapper = Com::Fasterxml::Jackson::Databind::ObjectMapper.new
    mapper.writeValueAsString(RubyToJava.convert_hash(hash));
  end

end
