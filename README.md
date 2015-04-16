# moran

moran is a simple JSON parser and generator for [RubyMotion Android](http://rubymotion.com) named after the famous jazz pianist [Jason Moran](http://en.wikipedia.org/wiki/Jason_Moran_%28musician%29). It provides a Ruby wrapper around the [Jackson JSON parser for Java.](https://github.com/FasterXML/jackson)

moran emulates the standard Ruby JSON API, providing `parse` and `generate` methods:

```ruby
hash = Moran.parse(json_string)
json_string = Moran.generate(hash)
```

It also adds convenience methods to `Hash` for generating JSON, and converting `org.json.JSONObject` instances into Hashes, which is handy for integrating with the Java libraries that use them:

```ruby
json_string = hash.to_json
hash = Hash.from_json_object(some_json_object)
```

## Setup

### Prerequisite

This gem uses [motion-gradle](https://github.com/HipByte/motion-gradle) to manage the Java dependencies, so you need to have Gradle installed. For full details, see the [motion-gradle README](https://github.com/HipByte/motion-gradle), but the basics are:

```shell
brew install gradle
```

then install `Extras/Android Support Repository` with the Android SDK Manager.

### Project Setup

Gemfile:

```ruby
gem "moran"
```

Install Gradle dependencies:

```shell
rake gradle:install
```

## Usage

### Parsing

```ruby
json = '{ my_dog: "has_fleas" }'
hash = Moran.parse(json)
hash["my_dog"]  => "has_fleas"
```

### Generating

```ruby
hash = { dog: { name: "Rex", fleas: true } }
json = Moran.generate(hash)
# or...
json = hash.to_json
```

### Converting org.json.JSONObject instances

```ruby
json_obj = Org::Json::JSONObject.new
json_obj.put("string", "dog")
json_obj.put("boolean", true)

hash = Hash.from_json_object(json_obj)
hash["string"]  => "dog"
hash["boolean"] => true
```

## Development

### Tests

There is a small suite of tests that covers the basics, and can be run the usual way:

```
rake spec
```
or
```
rake spec:device
```


