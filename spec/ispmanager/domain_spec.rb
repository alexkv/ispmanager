require 'spec_helper'
require 'fakeweb'

describe ISPManager::Domain do
	before( :each ) do
		ISPManager::Request.should_receive(:create).and_return <<REQUREST
{
"elem": [
	{
		"name": "site1.com",
		"ip": "8.8.8.8",
		"docroot": "\/www\/site1.com",
		"php": "on",
		"ssi": "on"
	},
	{
		"name": "site2.com",
		"ip": "8.8.8.8",
		"docroot": "\/www\/site2.com",
		"php": "on",
		"ssi": "on"
	}
]
}
REQUREST
		
	end

	subject { ISPManager::Domain.new :host => 'example.com', :user => 'user', :password => 'password'}

	describe "list" do

		it {should have(2).list}
	end
end
