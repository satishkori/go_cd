require 'chefspec'
require 'chefspec/berkshelf'


describe 'go_cd::server' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(file_cache_path: '/tmp/chef/cache').converge(described_recipe)
  end
  it 'includes the default recipe' do
    expect(chef_run).to include_recipe('go_cd::default')
  end
  it 'add gocd apt repository' do
    expect(chef_run).to add_apt_repository('gocd')
  end
  it 'install package go-server' do
    expect(chef_run).to install_package('go-server')
  end
  it 'enable go-server service' do
    expect(chef_run).to enable_service('go-server')
  end
  it 'start go-server service' do
    expect(chef_run).to start_service('go-server').with(
      supports: {
        status: true,
        start: true,
        stop: true,
        restart: true
      }
    )
    expect(chef_run).to enable_service('go-server').with(
      supports: {
        status: true,
        start: true,
        stop: true,
        restart: true
      }
    )
  end
end
