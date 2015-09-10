default['mo_bind']['bind_dir'] = '/etc/bind'
default['mo_bind']['cache_dir'] = '/var/cache/bind/cache'
default['mo_bind']['zones_dir'] = File.join(node['mo_bind']['bind_dir'], 'domain_zones')
default['mo_bind']['zones_databag'] = :dns_zones
default['mo_bind']['action_when_changing_zone'] = :restart
