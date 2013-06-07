Chef::Log.info("Setting up scheduler")

node[:deploy].each do |application, deploy|

  rails_env = deploy[:rails_env]
  release_path = deploy[:release_path]

  service "scheduler" do
    provider Chef::Provider::Service::Upstart
    action :stop
  end

  execute "export upstart config" do
    cwd release_path
    command "echo 'RAILS_ENV=#{rails_env}' > .env"
    command "sudo bundle exec foreman export upstart /etc/init --app scheduler --user deploy --log #{deploy[:deploy_to]}/shared/log --procfile deploy/Procfile.scheduler --root #{deploy[:deploy_to]}/current"
  end

  service "scheduler" do
    provider Chef::Provider::Service::Upstart
    action :start
  end

end