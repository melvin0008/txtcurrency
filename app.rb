require 'sinatra'
require 'twilio-ruby'
require 'json'
require 'rest-client'


Twilio.configure do |config|
	config.account_sid = ENV['ACCOUNT_SID']
	config.auth_token = ENV['AUTH_TOKEN']
end

post '/receive' do
	#@client= Twilio::REST::Client.new
	message=params[:Body].split(' ')
	if message.length ==1
		countryfrom=message[0]
		countryto=message[1]
		query="http://www.freecurrencyconverterapi.com/api/v2/convert?q=#{countryfrom}_#{countryto}&compact=y"
		api_result = RestClient.get query
		dict_result=JSON.parse(api_result)

		dict_result['main'].each do |w|
			title_tag = w[0]
			info_item = w[1]
			output << "<tr><td>#{title_tag}</td><td>#{info_item}</td></tr>"

			return 
		end
	end
end

get '/convert/:from/:to' do
	begin
		countryfrom=params[:from].upcase
		countryto=params[:to].upcase
		parameter="#{countryfrom}_#{countryto}"
		query="http://www.freecurrencyconverterapi.com/api/v2/convert?q=#{parameter}&compact=y"
		api_result = RestClient.get query
		dict_result=JSON.parse(api_result)

		return_val= "#{dict_result[parameter]['val']}"
		return return_val
	rescue NameError46
		return "Enter Proper format"
	end
end
# @client.messages.create(
# 			from:ENV['MY_NUMBER'],
# 			to:params[:From],
# 			body:'Yalla')
#curl -X POST https://api.twilio.com/2010-04-01/Accounts/AC7ce5e0e39730f8a683247bd5fcd50e29/Messages -d "To=+16179528889" -d "From=+15005550006" -d "Body=Hello" -u 'AC7ce5e0e39730f8a683247bd5fcd50e29:c2daecaf9d24322e41c1208006e41466'
#curl -X POST https://txtfoodie.herokuapp.com/receive -d "Body=yalla"
