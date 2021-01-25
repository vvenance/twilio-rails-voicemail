class TwilioController < ApplicationController
	skip_before_action :verify_authenticity_token

	def initial_answer
		response = Twilio::TwiML::VoiceResponse.new
		initial_answer = response.dial(number: ENV['my_phone_number'],
										timeout: 10,
										action: "/handle-unanswered-call",
										method: "GET")
		render xml: initial_answer
	end

	def handle_unanswered_call
		if params["DialCallStatus"] == "busy" || params["DialCallStatus"] == "no-answer" 
			render xml: voicemail_twiml
		end
	end

	def recordings
		mp3_recording_url = params["RecordingUrl"] + ".mp3"
		sms_notification = "You got an answerphone message from #{params["From"]} - listen here: #{mp3_recording_url}"

		client = Twilio::REST::Client.new
		client.messages.create(from: params["To"],
								to: ENV['my_phone_number'],
								body: sms_notification)

		head :ok
	end

	private

	def voicemail_twiml
		response = Twilio::TwiML::VoiceResponse.new
		
		response.pause(length: 2)
				.play(url: '/message.mp3')
				.record(play_beep: true, action: '/recordings')


		#.say(message: "Sorry I can't take your call at the moment, please leave a message")
				
	end
end