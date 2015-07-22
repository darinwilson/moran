class Moran

  module_function

  def parse(json)
    mapper = Com::Fasterxml::Jackson::Databind::ObjectMapper.new
    mapper.configure(Com::Fasterxml::Jackson::Core::JsonParser::Feature::ALLOW_UNQUOTED_FIELD_NAMES,
                     true)
    is_array = json.lstrip[0] == "["
    mapper.readValue(json, is_array ? Array : Hash)
  end

  def generate(obj)
    mapper = Com::Fasterxml::Jackson::Databind::ObjectMapper.new
    converted =
      if obj.is_a?(Array)
        RubyToJava.convert_array(obj)
      else
        RubyToJava.convert_hash(obj)
      end
    mapper.writeValueAsString(converted)
  end

end
