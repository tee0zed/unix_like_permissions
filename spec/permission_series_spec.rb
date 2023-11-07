require 'spec_helper'
require './lib/unix_like_permissions/permission_series'
PermissionSeries = UnixLikePermissions::PermissionSeries

RSpec.describe PermissionSeries do
  let(:permission_series) { PermissionSeries.new(0) }

  describe '#initialize' do
    it 'initializes with a value' do
      expect(permission_series.value).to eq(0)
    end
  end

  describe '#set' do
    it 'sets a permission' do
      permission_series.set(read: true)
      expect(permission_series.to_i).to eq(1)
    end

    it 'raises error for unknown permission' do
      expect { permission_series.set(unknown_permission: true) }.to raise_error(ArgumentError)
    end
  end

  describe '#set_all' do
    it 'sets all permissions to true' do
      permission_series.set_all(true)
      expect(permission_series.to_i).to eq(15)
    end

    it 'sets all permissions to false' do
      permission_series.set_all(false)
      expect(permission_series.to_i).to eq(0)
    end
  end

  describe '#to_i' do
    it 'returns the integer value of the permissions' do
      expect(permission_series.to_i).to be_a(Integer)
    end
  end

  describe '#to_a' do
    it 'returns permissions as an array of strings when type is :str' do
      expect(permission_series.to_a(:str)).to eq(["0", "0", "0", "0"])
    end
  end

  describe '#to_h' do
    it 'returns permissions as a hash' do
      permission_series.set(read: true)
      expect(permission_series.to_h).to eq({read: true, create: false, update: false, destroy: false})
    end
  end

  describe '#to_s' do
    it 'returns a string representation of the permissions' do
      permission_series.set(read: true, destroy: true)
      expect(permission_series.to_s).to eq("read destroy")
    end
  end
end
