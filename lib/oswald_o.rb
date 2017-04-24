require 'json'

class OswaldO
  def initialize(data, options = {})
    @data = options[:json] ? JSON.parse(data) : data

    if @data.is_a?(Array)
      @data = @data.map { |item| item.is_a?(Hash) ? OswaldO.new(item) : item }
    end
  end

  private

  def method_missing(m, *args, &block)
    super unless @data.respond_to?(m) || @data.has_key?(m) || @data.has_key?(m.to_s)

    value = if @data.respond_to?(m)
      @data.send(m, *args, &block)
    else
      @data[m] || @data[m.to_s]
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
