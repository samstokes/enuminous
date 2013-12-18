require 'set'

class Enum
  def initialize(value)
    self.class.validate! value
    @value = value.to_sym
  end

  def to_s
    @value.to_s
  end

  def inspect
    "#<#{self.class}: #{self}>"
  end

  def case(&block)
    Case.new(self).compile(&block).case
  end

  class << self
    def alidate!(val)
      unless values.member? val.to_sym
        raise ArgumentError, "Invalid #{self}: #{val}"
      end
    end

    def values
      @values ||= Set.new
    end

    private
    def value(val)
      values << val.to_sym
      instance = new(val)
      const_set val.to_s.upcase, instance
      define_method("#{val}?") { @value == val }
      instance
    end

    def def_case(name)
      define_method(name) {}
    end
  end

  class Case
    def initialize(enum)
      @values = enum.class.values
      @seen_values = Set.new

      @values.each do |value|
        singleton_class.send :define_method, "when_#{value}" do |&block|
          @seen_values << value.to_sym

          if enum.send "#{value}?"
            @matched_block = block
          end
        end
      end
    end

    def compile(&block)
      self.instance_eval(&block)
      missing_cases = @values - @seen_values
      raise MissingCaseError, missing_cases.map(&:to_s).join(', ') unless missing_cases.empty?
      self
    end

    def case
      @matched_block.call
    end
  end

  class MissingCaseError < ScriptError; end
end
