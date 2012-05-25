class ISPManager::Domain < ISPManager::Base
	
	def list
		request 'wwwdomain'
	end


end
