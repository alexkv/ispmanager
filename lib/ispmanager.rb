class ISPManager
	require 'ispmanager/base'
	require 'ispmanager/domain'

	def initialize params
		unless params[:host] && params[:user] && params[:password]
			raise RequireConnectionParams
		end
		params[:port] ||= 443
		@params = params
	end

	def domains
		@domains ||= ISPManager::Domain.new @params
	end

	class RequireConnectionParams < StandardError
	end

	class Request
		def self.create function, params, connection
			p connection
			http = Net::HTTP.new connection[:host], connection[:port]
			http.use_ssl = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			params ||= {}
			params[:authinfo] = "#{connection[:user]}:#{connection[:password]}"
			params[:out] = :json
			params[:func] = function
			query = URI.encode_www_form(params)
			path = "/manager/ispmgr?#{query}"
			request = Net::HTTP::Get.new(path)
			result = http.start {|http| http.request(request) }.body
		end


		class ::Hash
			def recursive_symbolize_keys!
				recursive_modify_keys! { |key| key.to_sym }
			end

			def recursive_stringify_keys!
				recursive_modify_keys! { |key| key.to_s }
			end

			#def symbolize_keys!
				#modify_keys! { |key| key.to_sym }
			#end

			#def stringify_keys!
				#modify_keys! {|key| key.to_s }
			#end

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
end
