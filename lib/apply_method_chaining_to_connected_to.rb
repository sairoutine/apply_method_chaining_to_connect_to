require "apply_method_chaining_to_connected_to/version"
require 'active_record'

module ApplyMethodChainingToConnectedTo
  module Model
    def self.extended(base)
      if atleast_rails61?
        raise Error, <<-EOF
  ApplyMethodChainingToConnectedTo needs rails version >= 6.1.
        EOF
      end

      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end

    def self.atleast_rails61?
      ActiveRecord::VERSION::MAJOR > 6 || (ActiveRecord::VERSION::MAJOR == 6 && ActiveRecord::VERSION::MINOR >= 1)
    end

    module InstanceMethods
      # def connected_to(database: nil, role: nil, shard: nil, prevent_writes: false, &blk)
      def connected_to(*args)

        if block_given?
          raise Error, <<-EOF
  #{name}.connected_to is not allowed to receive a block, it works just like a regular scope.
          EOF
        end

        ScopeProxy.new(args, self)
      end
    end

    module ClassMethods
    end
  end

  class ScopeProxy < BasicObject
    attr_accessor :klass

    # Dup and clone should be delegated to the class.
    # We want to dup the query, not the scope proxy.
    delegate :dup, :clone, to: :klass

    def initialize(args, klass)
      @args = args
      @klass = klass
    end

    def method_missing(method, *args, &block)
      result = run_on_shard { @klass.__send__(method, *args, &block) }
      if result.respond_to?(:all)
        return ::Octopus::ScopeProxy.new(current_shard, result)
      end

      if result.respond_to?(:current_shard)
        result.current_shard = current_shard
      end

      result
    end

    # Delegates to method_missing (instead of @klass) so that User.using(:blah).where(:name => "Mike")
    # gets run in the correct shard context when #== is evaluated.
    def ==(other)
      method_missing(:==, other)
    end
    alias_method :eql?, :==
  end

  module CaseFixer
    def ===(other)
      other = other.klass while ScopeProxy === other
      super
    end
  end
end

ActiveRecord::Base.extend(ApplyMethodChainingToConnectedTo::Model)
ActiveRecord::Relation.extend(ApplyMethodChainingToConnectedTo::ScopeProxy::CaseFixer)
