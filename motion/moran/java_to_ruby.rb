# Utility class that converts a java.util.HashMap instance to a Ruby Hash. RubyMotion will
# start supporting this out of the box at some point, but until then, this can be used
# as a workaround: http://hipbyte.myjetbrains.com/youtrack/issue/RM-725
#
# Usage:
#   JavaToRuby.convert_hashmap(hashmap)
#
# This supports nested hashes and should assure that all Java-based values are properly converted
# to their Ruby counterparts (i.e. java.lang.String => String).
#
# This has not been extensively tested, or optimized for performance. It should work well enough
# for simple cases, but may well fall over with a large HashMap.
#
class JavaToRuby

  class << self
    def convert_hashmap(hashmap)
      JavaToRuby.new.hashmap_to_hash(hashmap)
    end

    def convert_json_object(json_obj)
      JavaToRuby.new.json_object_to_hash(json_obj)
    end
  end

  def hashmap_to_hash(hm)
    return nil if hm.nil?
    Hash.new.tap do |h|
      it = hm.entrySet().iterator();
      while it.hasNext() do
        entry = it.next()
        h[entry.getKey()] = convert_value(entry.getValue())
        it.remove()
      end
    end
  end

  def json_object_to_hash(json_obj)
    return nil if (json_obj.nil? || json_obj.toString == "null")
    Hash.new.tap do |h|
      it = json_obj.keys()
      while it.hasNext() do
        key = it.next()
        h[key] = convert_value(json_obj.get(key))
        it.remove()
      end
    end
  end

  def json_array_to_array(json_array)
    return nil if json_array.nil?
    Array.new.tap do |a|
      inx = 0
      while inx < json_array.length() do
        a << convert_value(json_array.get(inx))
        inx += 1
      end
    end
  end
  private

  def convert_value(value)
    puts value.class
    new_value ||= hashmap_to_hash(value) if hashmap?(value)
    new_value ||= to_array(value)        if array?(value)
    new_value ||= to_boolean(value)      if boolean?(value)
    new_value ||= to_float(value)       if double?(value)
    new_value ||= json_object_to_hash(value) if json_object?(value)
    new_value ||= json_array_to_array(value) if json_array?(value)

    # Using ternary here so the null-turned-JSONObjects return nil
    # instead of the original value
    new_value ||= null?(value) ? nil : value
  end

  def hashmap?(value)
    value.class.to_s.end_with?("HashMap")
  end

  def array?(value)
    value.is_a?(Array)
  end

  def boolean?(value)
    ["true","false"].include?(value.to_s.downcase)
  end

  def json_object?(value)
    # If value is a null-turned-JSONObject, the class is java.lang.JSONObject$1
    # so we use include here
    value.class.to_s.include?("JSONObject")
  end

  def json_array?(value)
    value.class.to_s.end_with?("JSONArray")
  end

  def double?(value)
    value.class.to_s.end_with?("Double")
  end

  def null?(value)
    # If value is a null-turned-JSONObject, value.toString returns "null"
    value.nil? || value.to_s.downcase == "null" || (value.respond_to?("toString") && value.toString == "null")
  end

  def to_array(array)
    # currently, Java arrays are correctly converted to Array objects - we just need to make
    # sure that the values are correctly converted
    array.map { |value| convert_value(value) }
  end

  def to_float(value)
    value.to_s.to_f
  end

  def to_boolean(value)
    value.to_s.downcase == "true"
  end

end
