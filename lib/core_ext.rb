require 'active_support/core_ext/string'

module HashExtensions

  def camelize_keys!
    keys.each do |k|
      new_key = k.to_s.camelize(:lower)
      new_key = new_key.to_sym if k.is_a?(Symbol)
      v = self.delete(k)
      self[new_key] = case v
        when Hash
          v.camelize_keys!
        when Array
          v.each do |e|
            e.camelize_keys! if e.is_a?(Hash)
          end
        else
          v
      end
      self[new_key] = v
    end
    self
  end

end

Hash.include(HashExtensions)
