# Cookbook Name:: go-server
# Recipe:: default
include_recipe 'go_cd::default'

apt_repository 'gocd' do
  uri node['go_cd']['apt_repo_uri']
  components ['/']
end

package 'go-server' do
  version node['go_cd']['package_version']
  options '--force-yes'
  notifies :restart, 'service[go-server]'
end

service 'go-server' do
  action [ :enable, :start ]
  supports(
    status: true,
    start: true,
    stop: true,
    restart: true
  )
end

