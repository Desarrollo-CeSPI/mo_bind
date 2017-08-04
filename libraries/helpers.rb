def configure_dns_for(zones)
  define_zones(zones)
  update_databases(zones)
end

def define_zones(zones)
  template "#{node['mo_bind']['bind_dir']}/named.conf.local" do
    source 'etc/bind/named.conf.local.erb'
    variables ({
      zones: zones
    })
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    notifies :restart, 'service[bind9]'
  end
end

def update_databases(zones)
  zones.each do |zone|
    (template database_file_for(zone) do
      source 'etc/bind/zone_database.erb'
      variables ({
        zone: zone
      })
      owner 'root'
      group 'root'
      mode '0644'
      action :create
      notifies node['mo_bind']['action_when_changing_zone'], 'service[bind9]'
    end) if is_master?(zone)
  end
end

def sanitize_option(key, values)
  "#{key} { #{values.join('; ')}; };"
end

def zone_id(zone)
  zone['domain'] || zone['id']
end

def zone_definition(zone, key = nil, default = nil)
  scope = zone['zone_definition']
  scope = scope[key] if key
  scope || default || []
end

def join_ips(arr)
  "#{arr.join '; ' }#{arr.empty? ? '':';'}"
end

def dns_type_for(zone)
  (is_master? (zone)) ? "master" : "slave"
end

def dns_configuration_for_type(zone)
  if is_master?(zone)
    "type master;\n  allow-transfer { #{join_ips(zone_definition(zone, 'slaves'))} };"
  else
    "type slave;\n  masters { #{join_ips(zone_definition(zone, 'masters').join("; "))} };"
  end
end

private 

def is_master?(zone)
  zone_definition(zone, 'masters').include? node['ipaddress']
end

def directory_for_zone(zone)
  if is_master?(zone)
    node['mo_bind']['zones_dir']
  else
    "cache"
  end
end

def database_file_for(zone)
  "#{directory_for_zone(zone)}/db.#{zone_id(zone)}"
end

