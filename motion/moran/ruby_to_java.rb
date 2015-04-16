# Type conversion between Ruby and Java is still not as seamless as one would like. Strings
# in particular get mangled when passed into Jackson
class RubyToJava

  def self.convert_hash(hash)
    RubyToJava.new.to_hashmap(hash)    
  end

  def to_hashmap(old_hash)
    Hash.new.tap do |h|
      old_hash.keys.each do |key|
        h[key] = convert_value(old_hash[key])
      end
    end
  end

  private

  def convert_value(value)
    new_value ||= to_hashmap(value)     if value.is_a?(Hash)
    new_value ||= convert_array(value)  if value.is_a?(Array)
    new_value ||= value.toString        if value.is_a?(String)
    new_value ||= value
  end

  def convert_array(array)
    array.map { |v| v.is_a?(String) ? v.toString : v }
  end

end
