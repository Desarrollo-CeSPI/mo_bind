package 'bind9'
service 'bind9'

# Looks for every zone defined in the databag in which the server is either master or slave.
zones = search(node['mo_bind']['zones_databag'], "masters:*#{node['ipaddress']}* OR slaves:*#{node['ipaddress']}*")

configure_dns_for(zones)
