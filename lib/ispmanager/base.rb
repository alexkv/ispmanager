require 'net/http'
require 'net/https'
require 'json'

class ISPManager::Base
	def initialize params
		@params = params
	end

	protected

	def request method, params = {}
		result = ISPManager::Request.create method, params, @params
		result = JSON.parse(result)
		if result.is_a? Hash
			result.recursive_symbolize_keys!
			return result[:elem] ? result[:elem] : result
		end
	end

	class ::Hash
		def recursive_symbolize_keys!
			recursive_modify_keys! { |key| key.to_sym }
		end

		protected
		def modify_keys!
			keys.each do |key|
				self[(yield(key) rescue key) || key] = delete(key)
			end
			self
		end

		def recursive_modify_keys! &block
			modify_keys!(&block)
			values.each { |h| h.recursive_modify_keys!(&block) if h.is_a?(Hash) }
			values.select { |v| v.is_a?(Array) }.flatten.each { |h| h.recursive_modify_keys!(&block) if h.is_a?(Hash) }
			self
		end
	end
end
