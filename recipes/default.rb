package 'bind9'
service 'bind9'

directory node['mo_bind']['zones_dir']

directory node['mo_bind']['cache_dir'] do
  owner 'bind'
  group 'bind'
end

template "#{node['mo_bind']['bind_dir']}/named.conf.options" do
  source 'etc/bind/named.conf.options.erb'
  variables ({
    cache_base_dir: node['mo_bind']['cache_base_dir'],
    forwarders: node['mo_bind']['forwarders'],
    allow_recursion: node['mo_bind']['allow_recursion']
  })
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :restart, 'service[bind9]'
end

# Looks for every zone defined in the databag in which the server is either master or slave.
zones = search(node['mo_bind']['zones_databag'], "masters:*#{node['ipaddress']}* OR slaves:*#{node['ipaddress']}*")

configure_dns_for(zones)
