Chef::Log.info("Deploying foreman")

node[:deploy].each do |application, deploy|
  node[:opsworks][:instance][:layers].each do |layer_name|
    Chef::Log.info("Deploying foreman for #{layer_name}")

    service layer_name do
      provider Chef::Provider::Service::Upstart
      action :stop
      only_if { File.exists?("/etc/init/#{layer_name}.conf") && `status #{layer_name}`.include?("start") }
    end

    execute "export upstart config" do
      cwd deploy[:current_path]
      command "echo 'RAILS_ENV=#{deploy[:rails_env]}' > .env"
      command "sudo bundle exec foreman export upstart /etc/init --app #{layer_name} --user deploy --log #{deploy[:deploy_to]}/shared/log --procfile deploy/Procfile.#{layer_name} --root #{deploy[:current_path]}"
      only_if { File.exists?("deploy/Procfile.#{layer_name}") }
    end

    service layer_name do
      provider Chef::Provider::Service::Upstart
      action :start
      only_if { File.exists?("/etc/init/#{layer_name}.conf") && `status #{layer_name}`.include?("stop") }
    end
  end
end