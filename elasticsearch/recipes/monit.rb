template "/etc/monit/conf.d/elasticsearch-monit.conf" do
  source "monitrc.conf.erb"
  mode 0440
  owner "root"
  group "root"
end
