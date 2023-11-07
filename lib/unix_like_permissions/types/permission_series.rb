require_relative '../permission_series'

raise 'You must load ActiveRecord first!' unless defined?(::ActiveRecord)

module UnixLikePermissions
  module Types
    class PermissionSeries < ActiveRecord::Type::Value
      def type
        :integer
      end

      def cast(value)
        ::UnixLikePermissions::PermissionSeries.new(value)
      end

      def deserialize(value)
        ::UnixLikePermissions::PermissionSeries.new(value)
      end

      def serialize(value)
        value.value
      end
    end
  end
end
