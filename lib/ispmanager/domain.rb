class ISPManager::Domain < ISPManager::Base
	def all
		request 'wwwdomain'
	end
end
