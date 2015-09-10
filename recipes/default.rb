package 'bind9'
service 'bind9'

directory node['mo_bind']['zones_dir']

directory node['mo_bind']['cache_dir'] do
  owner 'bind'
  group 'bind'
end

# Looks for every zone defined in the databag in which the server is either master or slave.
zones = search(node['mo_bind']['zones_databag'], "masters:*#{node['ipaddress']}* OR slaves:*#{node['ipaddress']}*")

configure_dns_for(zones)
