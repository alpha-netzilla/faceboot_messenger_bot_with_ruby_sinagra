#!/usr/bin/ruby

require "sinatra"
require "sinatra/reloader" if development?
require 'rest-client'
require "json"

$stdout.sync = true

set :port, ENV['PORT'] || 4567

# A chat_bot_id equals a facebook page id which we can see on facebook bage.
set :chat_bot_id, ENV['CHAT_BOT_ID']

# Page access token which we can see on facebook developper page.
set :page_token, ENV['PAGE_TOKEN']
set :endpoint, "https://graph.facebook.com/v2.6/me/messages?access_token=#{settings.page_token}"

# An arbitrary token which we can creat on facebook developer page.
set :verify_token, ENV['VERIFY_TOKEN']


get '/callback' do
  if params['hub.verify_token'] == settings.verify_token
    params['hub.challenge']
    status 200
    body 'OK'
  else
    status 401
    body 'Authentication error'
  end
end


post '/callback' do
  begin
    request.body.rewind
    request_body = JSON.parse(request.body.read)

    status 200
    body ''

  rescue Exception => e
    status 400
    body ''

    puts e.message
  end


  create_bot_response(request_body)
end


def create_bot_response(request_body)
  begin
    contents = request_body['entry'][0]['messaging'][0]

    sender = contents['sender']['id']
    return if sender == settings.chat_bot_id

    if contents['message'] != nil
      text = contents['message']['text']
    elsif contents['postback'] != nil
      text = contents['postback']['payload']
    else
      return
    end

    if text.match(/aaa/i)
      bot_response = response_with_text(sender, 'test aaa')
    elsif text.match(/bbb/i)
      bot_response = response_with_image(sender, 'test bbb')
    elsif text.match(/ccc/i)
      bot_response = response_with_button(sender, 'test ccc', *create_buttons)
    elsif text.match(/ddd/i)
      bot_response = response_with_quick_button(sender, 'test ddd', *create_quick_buttons)
    else
      puts "DEBUG: No Response(#{text})"
      return
    end
    RestClient.post settings.endpoint, bot_response, content_type: :json, accept: :json
  rescue Exception => e
    puts e.message
  end
end


def response_with_text(sender, text)
  body = {
    recipient: {
      id: sender
    },
    message: {
      text: text
    }
  }.to_json

end


def response_with_image(sender, text)
  body = {
    recipient: {
      id: sender
    },
    message: {
      attachment: {
        type: 'image',
        payload: {
          url: 'https://scontent-hkg3-1.xx.fbcdn.net/t39.2365-6/12056999_527586047417155_1427094715_n.jpg'
        }
      }
    }
  }.to_json
end


def response_with_button(sender, text, *buttons)
  body = {
    recipient: {
      id: sender
    },
    message: {
      attachment: {
        type: 'template',
        payload: {
          template_type: "button",
          text: text,
          buttons: buttons
        }
      }
    }
  }.to_json
end


def create_buttons
  [
    {
      type: "postback",
      title: "today",
      payload: "today"
    },
    {
      type: "postback",
      title: "tomorrow",
      payload: "tomorrow"
    },
    {
      type: "web_url",
      url: "https://example.com/",
      title: "other"
    }
  ]
end


def response_with_quick_button(sender, text, *quick_buttons)
  body = {
    recipient: {
      id: sender
    },
    message: {
      text: text,
      quick_replies: quick_buttons
    }
  }.to_json
end


def create_quick_buttons
  [
    {
      content_type: "text",
      title: "Red",
      payload: "red"
    },
    {
      content_type: "text",
      title: "Green",
      payload: "green"
    },
    {
      content_type: "text",
      title: "Blue",
      payload: "blue"
    }
  ]
end
