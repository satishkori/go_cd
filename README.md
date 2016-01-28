## go_cd Cookbook
[Chef](https://www.chef.io/chef/) cookbook for managing [GoCD](http://www.go.cd/).

### Description
This cookbook install and configures ThoughtWorks GoCD server and agent.
This cookbook is adapted from the other community [GoCD cookbook](https://github.com/ketan/thoughtworks-go-cookbooks) to support running agents as custom user.

### Usage

Either assign the relevent recipes (server or agent) directly to node's run list or use `include_recipe` from wrapper recipes.

The agent recipe uses `node['go_cd']['server_ip']` attribute to configure the GoCD server. By default this points to localhost. If you are using chef solo, use role or environment to override this value, if you are using chef search capabilties, you can use wrapper recipes as well to specify the GoCD server ip. Example:

```ruby
node.default['go_cd']['server_ip'] = search(:node, 'name:gocd-server').first.ipaddress
include_recipe 'go_cd::agent'
```

This cookbook is used along side [container](https://github.com/GoatOS/container) and [xml_file](https://github.com/GoatOS/xml_file) cookbooks to create Continuous Integration servers, capable of running unprivileged LXC containers as part of their [build/test pipelines](https://github.com/GoatOS/GoatOS). An example can be found [here](https://github.com/GoatOS/go_cd/blob/master/functional/lxc_spec.rb) (dogfood :-))

## License
[Apache 2](http://www.apache.org/licenses/LICENSE-2.0)


## Contributing

1. Fork it ( https://github.com/GoatOS/go_cd/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
