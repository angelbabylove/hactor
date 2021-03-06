require 'json'
require 'delegate'
require 'forwardable'
require 'hactor/hal/resource'

module Hactor
  module HAL
    class Document < Delegator
      extend Forwardable

      attr_reader :body, :response, :resource_class

      def_delegators :response, :http_client

      def initialize(body, options={})
        @response = options.fetch(:response)
        @resource_class = options[:resource_class] || Hactor::HAL::Resource
        body = '{}' if body == 'null'
        @body = JSON.parse(body)
      end

      def __getobj__
        root_resource
      end

      def root_resource
        @root_resource ||= resource_class.new(body, rel: 'self', context: self)
      end

      def base_url
        response.env[:url]
      end
    end
  end
end
