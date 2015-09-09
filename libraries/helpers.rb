def configure_dns_for(zones)
  define_zones(zones)
  #update_zone_database
end

def define_zones(zones)
  template "#{node['mo_bind']['bind_dir']}/named.conf.local" do
    source 'etc/bind/named.conf.local.erb'
    variables ({
      zones: zones,
      zones_dir: node['mo_bind']['zones_dir']
    })
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    notifies :restart, 'service[bind9]'
  end
end

def sanitize_option(key, values)
  "#{key} { #{values.join('; ')}; };"
end

def zone_id(zone)
  zone['domain'] || zone['id']
end

def zone_file(zone)
  "#{directory_for_zone(zone)}/#{zone_id(zone)}"
end

def zone_definition(zone, key = nil, default = nil)
  scope = zone['zone_definition']
  scope = scope[key] if key
  scope || default
end

def dns_type_for(zone)
  (is_master? (zone_definition(zone))['masters']) ? "master" : "slave"
end

private 

def is_master?(masters)
  masters.include? node['ipaddress']
end

def directory_for_zone(zone)
  if is_master?(zone_definition(zone, 'masters'))
    node['mo_bind']['zones_dir']
  else
    "cache"
  end
end

