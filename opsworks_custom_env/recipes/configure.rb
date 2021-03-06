# Set up app's custom configuration in the environment.
# See https://forums.aws.amazon.com/thread.jspa?threadID=118107

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]
  
  template "#{deploy[:deploy_to]}/shared/config/application.yml" do
    source "application.yml.erb"
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:env => node[:custom_env][application])

    only_if do
      File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/shared/config/")
    end
  end
  
end
