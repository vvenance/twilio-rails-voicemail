Rails.application.routes.draw do
  get '/initial-answer', action: :initial_answer, controller: 'twilio'
  get '/handle-unanswered-call', action: :handle_unanswered_call, controller: 'twilio'
  post '/recordings', action: :recordings, controller: 'twilio'
end
