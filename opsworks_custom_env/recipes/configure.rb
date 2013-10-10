# Set up app's custom configuration in the environment.
# See https://forums.aws.amazon.com/thread.jspa?threadID=118107

include_recipe "rails::configure"

node[:deploy].each do |application, deploy|
  
  template "#{deploy[:deploy_to]}/shared/config/application.yml" do
    source "application.yml.erb"
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:env => node[:custom_env][application])

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/shared/config/")
    end
  end
  
end
