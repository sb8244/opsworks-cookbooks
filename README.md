# Cool Tricks

## Get Opsworks JSON in Ruby

Opsworks uses a json hash to pass parameters to Chef. This can be a pain to test.
This trick will allow you to access the JSON in Ruby just like you were in Chef!

* SSH into remote AWS instance
* sudo your session
* irb

```ruby
require 'json'
json = `opsworks-agent-cli get_json`
node = JSON.parse(json, symbolize_names: true)
# Access your node[:deploy] or node[:opsworks][:instance] just like your script will!
```