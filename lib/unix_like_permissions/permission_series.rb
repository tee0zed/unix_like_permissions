module UnixLikePermissions
  class PermissionSeries
    PermissionSeriesError = Class.new(StandardError)

    PERMISSIONS_MAP = {
      read: 1,
      create: 2,
      update: 4,
      destroy: 8
    }.freeze

    TRUE_ID = true.object_id
    FALSE_ID = false.object_id
    ALL_TRUE = PERMISSIONS_MAP.values.sum
    ALL_FALSE = 0

    attr_reader :value

    def initialize(value)
      @value = value
    end

    def set(values)
      raise ArgumentError, "Unknown permission #{values.keys - PERMISSIONS_MAP.keys}" unless values.keys.all? { |permission| PERMISSIONS_MAP.key?(permission) }
      raise ArgumentError, "Value must be boolean" unless values.values.all? { |value| value.object_id == FALSE_ID || value.object_id == TRUE_ID }

      # binary values for each permission
      #
      # |1   | |2     | |4     | |8      |
      # |0001| |0010  | |0100  | |1000   |
      # |read| |create| |update| |destroy|
      #
      # when we do binary | (or) operation with 0001 and 0100 we get 0101 which is considered as set CREATE to true and is decimal 5 (1 | 4 = 5)
      # when we do binary & (and) operation with 0101 and 1011(reverted: '~', 0100) we get 0001 which is considered as set CREATE to false and is decimal 1 (5 & ~4 = 1)
      values.each do |permission, value|
        if value
          @value = self.to_i | PERMISSIONS_MAP[permission]
        else
          @value = self.to_i & ~PERMISSIONS_MAP[permission]
        end
      end

      @stringified_permissions = nil
      @value
    end

    def self.define_getters!
      if defined?(PERMISSIONS_MAP_WAS)
        PERMISSIONS_MAP_WAS.keys.each do |permission|
          remove_method "#{permission.to_s.gsub(/[^\w]/, '_')}?"
        end
      end

      PERMISSIONS_MAP.keys.each do |permission|
        define_method "#{permission.to_s.gsub(/[^\w]/, '_')}?" do
          peek(permission)
        end
      end
    rescue StandardError => e
      raise PermissionSeriesError, e.message
    end

    def peek(permission)
      raise ArgumentError, "Unknown permission #{permission}" unless PERMISSIONS_MAP.key?(permission)

      # binary values for each permission
      #
      # |1   | |2     | |4     | |8      |
      # |0001| |0010  | |0100  | |1000   |
      # |read| |create| |update| |destroy|
      #
      # when we do binary & (and) operation with 0101 and 0010 we get 0000 which is considered as CREATE is false and is decimal 0 (5 & 2 = 0)
      # when we do binary & (and) operation with 0101 and 0100 we get 0100 which is considered as UPDATE is true and is decimal 4 (5 & 4 = 4)
      (self.to_i & PERMISSIONS_MAP[permission]) > 0
    end

    def set_all(value)
      @value = value ? ALL_TRUE : ALL_FALSE
      @stringified_permissions = nil
      @value
    end

    def to_i
      @value.to_i
    end

    def to_a(type = :str)
      case type
      when :str
        stringified_permissions.chars
      when :int
        stringified_permissions.chars.map(&:to_i)
      when :bool
        stringified_permissions.chars.map { |action| action == '1' }
      else
        raise ArgumentError, "Unknown type #{type}"
      end
    end

    def to_h(type = :bool)
      PERMISSIONS_MAP.keys.zip(self.to_a(type)).to_h
    end

    def to_s
      result = ''

      stringified_permissions.each_char.with_index do |action, i|
        if action == '1'
          result << ' ' unless i.zero?
          permissions = PERMISSIONS_MAP.keys
          result << permissions[i].to_s
        end
      end

      result
    end

    private

    def stringified_permissions
      @stringified_permissions ||= @value.to_s(2).rjust(PERMISSIONS_MAP.size, '0').reverse
    end
  end
end
