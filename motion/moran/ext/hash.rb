class Hash

  def to_json
    Moran.generate(self)   
  end

  def self.from_json_object(json_obj)
    JavaToRuby.convert_json_object(json_obj)
  end

end
