require 'sinatra'
require 'twilio-ruby'
require 'json'
require 'rest_client'


Twilio.configure do |config|
	config.account_sid = ENV['ACCOUNT_SID']
	config.auth_token = ENV['AUTH_TOKEN']
end

post '/convert' do
	#@client= Twilio::REST::Client.new
	message=params[:Body].split(' ')
	if message.length ==2
		begin
			countryfrom=message[0].upcase
			countryto=message[1].upcase
			parameter="#{countryfrom}_#{countryto}"
			query="http://www.freecurrencyconverterapi.com/api/v2/convert?q=#{parameter}&compact=y"
			api_result = RestClient.get query
			dict_result=JSON.parse(api_result)
			return_val= "1 #{countryfrom} => #{dict_result[parameter]['val']} #{countryto}"
			# @client.messages.create(
			# 	from:ENV['MY_NUMBER'],
			# 	to:params[:From],
			# 	body:return_val)
			from=params[:From]
			return "#{return_val} #{from} #{ENV['ACCOUNT_SID']}#{ENV['AUTH_TOKEN']}"
		rescue NameError
			# @client.messages.create(
			# 	from: ENV['MY_NUMBER'],
			# 	to: params[:From],
			# 	body: 'Invalid request'
			# 	)
		end
	else
		# @client.messages.create(
		# 	from: ENV['MY_NUMBER'],
		# 	to: params[:From],
		# 	body: 'Invalid request'
		# 	)
	end
end

get '/' do
	"Yalla"
end