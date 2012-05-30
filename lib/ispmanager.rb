require 'uri'

class ISPManager
	require 'ispmanager/base'
	require 'ispmanager/domain'

	def initialize params
		unless params[:url] && params[:user] && params[:password]
			raise RequireConnectionParams
		end

		params[:uri] = URI params[:url]
		@params = params
	end

	def domains
		@domains ||= ISPManager::Domain.new @params
	end

	class RequireConnectionParams < StandardError
	end

	class Request
		def self.create function, params, connection
			uri = connection[:uri]
			http = Net::HTTP.new uri.host, uri.port
			http.use_ssl = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			params ||= {}
			params[:authinfo] = "#{connection[:user]}:#{connection[:password]}"
			params[:out] = :json
			params[:func] = function
			query = URI.encode_www_form(params)
			url = "#{uri.url}/ispmgr?#{query}"
			request = Net::HTTP::Get.new(url)
			result = http.start {|http| http.request(request) }.body
		end
	end
end
