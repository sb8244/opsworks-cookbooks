Chef::Log.info("Configuring scheduler")

node[:deploy].each do |application, deploy|

  execute "export upstart config" do
    cwd deploy[:current_path]
    command "echo 'RAILS_ENV=#{deploy[:rails_env]}' > .env"
    command "sudo bundle exec foreman export upstart /etc/init --app scheduler --user deploy --log #{deploy[:deploy_to]}/shared/log --procfile deploy/Procfile.scheduler --root #{deploy[:current_path]}"
  end

end