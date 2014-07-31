node.default['nginx']['default_root'] = '/usr/share/nginx/html'

include_recipe 'nginx::ohai_plugin'

if platform_family?('rhel')
  package "nginx" do
    action :install
    version node['nginx']['version']
    notifies :reload, 'ohai[reload_nginx]', :immediately
    not_if 'which nginx'
  end
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action   :enable
end

if node['nginx']['default_site_enabled']
  cookbook_file "#{node['nginx']['dir']}/conf.d/default.conf" do
    source 'default.conf'
    owner 'root'
    group node['root_group']
    mode 00644
  end
end

include_recipe 'nginx::commons'