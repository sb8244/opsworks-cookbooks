Chef::Log.info("Precompiling assets...")

node[:deploy].each do |application, deploy|
  execute "rake assets:precompile" do
    cwd deploy[:current_path]
    command "bundle exec rake assets:precompile"
  end
end
