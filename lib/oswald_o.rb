class OswaldO
  def initialize(hash)
    @hash = hash
  end

  def method_missing(m, *args, &block)
    super unless @hash.has_key?(m) || @hash.has_key?(m.to_s)
    
    value = @hash[m] || @hash[m.to_s]

    if value.is_a?(Hash)
      OswaldO.new(value)
    elsif value.is_a?(Array) 
      value.map { |item| item.is_a?(Hash) ? OswaldO.new(item) : item }
    else
      value
    end
  end
end