def registers_for(zone)
  zone['zone_database']['registers']
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
