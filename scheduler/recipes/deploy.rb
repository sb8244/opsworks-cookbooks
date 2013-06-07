Chef::Log.info("Deploying scheduler")

node[:deploy].each do |application, deploy|

  service "scheduler" do
    provider Chef::Provider::Service::Upstart
    action :stop
    only_if { File.exists?("/etc/init/scheduler.conf") && `status scheduler`.include?("start") }
  end

  execute "export upstart config" do
    cwd deploy[:current_path]
    command "echo 'RAILS_ENV=#{deploy[:rails_env]}' > .env"
    command "sudo bundle exec foreman export upstart /etc/init --app scheduler --user deploy --log #{deploy[:deploy_to]}/shared/log --procfile deploy/Procfile.scheduler --root #{deploy[:current_path]}"
  end

  service "scheduler" do
    provider Chef::Provider::Service::Upstart
    action :start
    only_if { File.exists?("/etc/init/scheduler.conf") && `status scheduler`.include?("stop") }
  end

end