require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ISPManager do
	let(:params){{url: 'https://example.com/manager', user: 'user', password: 'password'}}

	it "should not raise exceptions" do
		ISPManager.new params
	end

	it "should require host" do
		params.delete(:url)
		expect {ISPManager.new params}.should raise_exception( ISPManager::RequireConnectionParams)
	end

	it "should require user" do
		params.delete(:user)
		expect {ISPManager.new params}.should raise_exception( ISPManager::RequireConnectionParams)
	end

	it "should require password" do
		params.delete(:password)
		expect {ISPManager.new params}.should raise_exception( ISPManager::RequireConnectionParams)
	end
end
