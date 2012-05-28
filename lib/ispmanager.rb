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
	end
end
