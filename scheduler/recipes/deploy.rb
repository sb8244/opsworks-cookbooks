Chef::Log.info("Deploying scheduler")

node[:deploy].each do |application, deploy|

  service "scheduler" do
    provider Chef::Provider::Service::Upstart
    action :restart
  end

end