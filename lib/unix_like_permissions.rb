# frozen_string_literal: true

require_relative 'unix_like_permissions/version'
require_relative 'unix_like_permissions/permission_series'

module UnixLikePermissions
  extend self

  PermissionSeries.define_getters!

  def create(permissions)
    PermissionSeries.new(permissions)
  end

  def load_permissions_map!(permissions)
    PermissionSeries.send(:remove_const, :PERMISSIONS_MAP_WAS) if defined?(PermissionSeries::PERMISSIONS_MAP_WAS)
    PermissionSeries.const_set(:PERMISSIONS_MAP_WAS, PermissionSeries::PERMISSIONS_MAP)

    PermissionSeries.send(:remove_const, :PERMISSIONS_MAP) if defined?(PermissionSeries::PERMISSIONS_MAP)
    PermissionSeries.const_set(:PERMISSIONS_MAP, permissions_map(permissions))

    PermissionSeries::PERMISSIONS_MAP.freeze
    PermissionSeries::PERMISSIONS_MAP_WAS.freeze

    PermissionSeries.define_getters!
    puts "Permission map loaded: #{PermissionSeries::PERMISSIONS_MAP}"
  end

  def permissions_map(permissions)
    raise ArgumentError("Permission map must be array of symbols!") unless permissions.is_a?(Array) && permissions.all? { |permission| permission.is_a?(Symbol) }

    permissions.map.with_index do |permission, index|
      [permission, 2**index]
    end.to_h
  end
end
