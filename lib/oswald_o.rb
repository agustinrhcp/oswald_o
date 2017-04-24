require 'json'

class OswaldO
  def initialize(data, options = {})
    @hash = options[:json] ? JSON.parse(data) : data
  end

  def method_missing(m, *args, &block)
    super unless @hash.respond_to?(m) || @hash.has_key?(m) || @hash.has_key?(m.to_s)

    value = if @hash.respond_to?(m)
      @hash.send(m, *args, &block)
    else
      @hash[m] || @hash[m.to_s]
    end

    if value.is_a?(Hash)
      OswaldO.new(value)
    elsif value.is_a?(Array)
      value.map { |item| item.is_a?(Hash) ? OswaldO.new(item) : item }
    else
      value
    end
  end
end
