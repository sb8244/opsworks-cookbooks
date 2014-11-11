Chef::Log.info("Deploying workers")

node[:deploy].each do |application, deploy|
  service application do
    provider Chef::Provider::Service::Upstart
    action :stop
    only_if { File.exists?("/etc/init/#{application}.conf") && `status #{application}`.include?("start") }
  end

  execute "export upstart config" do
    cwd deploy[:current_path]
    command "echo 'RAILS_ENV=#{deploy[:rails_env]}' > .env"
    command "bundle exec foreman export upstart /etc/init --app #{application} --user deploy --log #{deploy[:deploy_to]}/shared/log --procfile deploy/Procfile --root #{deploy[:current_path]}"
  end

  service application do
    provider Chef::Provider::Service::Upstart
    action :start
    only_if { File.exists?("/etc/init/#{application}.conf") && `status #{application}`.include?("stop") }
  end
end
