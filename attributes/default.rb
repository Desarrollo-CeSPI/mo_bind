default['mo_bind']['bind_dir'] = '/etc/bind'
default['mo_bind']['zones_dir'] = File.join(node['mo_bind']['bind_dir'], 'domain_zones')
default['mo_bind']['zones_databag'] = :dns_zones
