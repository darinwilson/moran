class Moran

  module_function

  def parse(json)
    mapper = Com::Fasterxml::Jackson::Databind::ObjectMapper.new
    mapper.configure(Com::Fasterxml::Jackson::Core::JsonParser::Feature::ALLOW_UNQUOTED_FIELD_NAMES,
                     true)
    mapper.readValue(json, Hash)
  end

  def generate(hash)
    mapper = Com::Fasterxml::Jackson::Databind::ObjectMapper.new
    mapper.writeValueAsString(RubyToJava.convert_hash(hash));
  end

end
