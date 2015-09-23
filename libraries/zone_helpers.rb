def registers_for(zone)
  registers = zone['zone_database']['registers']
  if zone['includes']
    zone['includes'].each do |included_zone|
      extra_zone = Chef::DataBagItem.load(node['mo_bind']['zones_databag'], included_zone)
      Chef::Mixin::DeepMerge.deep_merge!((extra_zone['registers']), registers)
    end
  end
  registers
end

def create_register_from(value, type, key = nil)
  value = normalize_register_with(value)
  "#{key || ""} #{value[:ttl]} IN #{type.upcase} #{value[:value]}"
end

def zone_database(zone, key = nil, default = nil)
  scope = zone['zone_database']
  scope = scope[key] if key
  scope || default
end

private

def normalize_register_with(value)
  if value.kind_of? String
    {
      value: value,
      ttl: ""
    }
  else
    value
  end
end
