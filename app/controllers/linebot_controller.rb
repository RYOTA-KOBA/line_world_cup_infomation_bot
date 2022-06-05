class LinebotController < ApplicationController
  require 'line/bot'

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
        end
      end
      client.reply_message(event['replyToken'], message)
    end
    head :ok
  end

private

# LINE Developers登録完了後に作成される環境変数の認証
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = '3e530878c7d32cb22071e8e62308790a'
      config.channel_token = 'dlJam+9JQICiP6I79CQLtzFl/86jsXl0XpK22ONRVU4EYOVUlf2TyLSGh/sxQETpcJRNSCBFFUU+wzFfb6x7R2TGsWYXdoBLbm0AnkwTwvjtKtyzoUqz+wA9wKAWhIuF5cQZ5eB2F/j0dthp0qmZXgdB04t89/1O/w1cDnyilFU='
    }
  end
end
