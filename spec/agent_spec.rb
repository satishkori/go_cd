require 'chefspec'
describe 'go_cd::agent' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(file_cache_path: '/var/chef/cache') do |node|
      node.set['go_cd']['server_ip'] = '1.1.1.1'
    end.converge(described_recipe)
  end
  it 'includes default recipe' do
    expect(chef_run).to include_recipe('go_cd::default')
  end
  %w(
    /usr/share/go-agent
    /var/lib/go-agent
    /var/run/go-agent
    /var/log/go-agent
    /var/lib/go-agent/config
  ).each do |dir|
    it "creates directory #{dir}" do
      expect(chef_run).to create_directory(dir).with(
        owner: 'go',
        group: 'go',
        mode: 0755
      )
    end
  end
  it 'download the agent zip file' do
    zipfile = File.join(Chef::Config[:file_cache_path], 'go-agent-15.1.0-1863.zip')
    expect(chef_run).to create_remote_file(zipfile).with(
      owner: 'go',
      group: 'go',
      source: 'http://download.go.cd/gocd/go-agent-15.1.0-1863.zip',
      mode: 0644
    )
  end
  it 'extracts zip file' do
    expect(chef_run).to run_execute('extract_zip').with(
      command: 'unzip go-agent-15.1.0-1863.zip',
      cwd: Chef::Config[:file_cache_path],
      creates: '/var/chef/cache/go-agent-15.1.0/agent-bootstrapper.jar',
    )
  end
  it 'copy over the bootstrapper jar' do
    expect(chef_run).to create_remote_file('/usr/share/go-agent/agent-bootstrapper.jar').with(
      source: 'file:///var/chef/cache/go-agent-15.1.0/agent-bootstrapper.jar',
      owner: 'go',
      group: 'go'
    )
  end
  it 'creates go-agent environment variable config' do
    expect(chef_run).to create_template('/etc/default/go-agent').with(
      owner: 'go',
      group: 'go',
      mode: 0644,
      source: 'agent_config.sh.erb',
      variables: {
        server_host: '1.1.1.1',
        server_port: 8153,
        work_dir: '/var/lib/go-agent',
        java_home: '/usr/lib/jvm/default-java/jre',
        agent_mem: '256M',
        agent_max_mem: '1024M'
      }
    )
  end
  it 'creates go agent Sys V init script' do
    expect(chef_run).to create_template('/etc/init.d/go-agent').with(
      owner: 'go',
      group: 'go',
      source: 'agent_init.sh.erb',
      mode: 0751
    )
  end
  it 'creates agent startup shell script' do
    expect(chef_run).to create_template('/usr/share/go-agent/agent.sh').with(
      owner: 'go',
      group: 'go',
      source: 'agent_start.sh',
      mode: 0751
    )
  end
  it 'creates log4j config' do
    expect(chef_run).to create_template('/var/lib/go-agent/log4j.properties' ).with(
      owner: 'go',
      group: 'go',
      source: 'log4j.properties.erb',
      mode: 0644
    )
  end
  it 'start and enable go-agent service' do
    expect(chef_run).to start_service('go-agent').with(
      supports: { status: true }
    )
    expect(chef_run).to enable_service('go-agent').with(
      supports: { status: true }
    )
  end
end
