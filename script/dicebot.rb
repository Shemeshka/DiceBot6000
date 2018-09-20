require 'discordrb'
require 'roller'

bot = Discordrb::Bot.new(token: Rails.configuration.discord_token)

bot.message(content: 'Ping!') do |event|
  event.respond 'Pong!'
end

bot.message(start_with: '!roll ') do |event|
  roll_text = event.content.sub(/^!roll /,'')
  roller = Roller.new
  roll = roller.roll(roll_text)
  event.respond "#{event.author.mention} rolled #{roll}"
end

bot.message(start_with: '!secretroll') do |event|
  roll_text = event.content.sub(/^!secretroll /,'')
  roller = Roller.new
  roll = roller.roll(roll_text)
  event.user.pm "#{event.author.mention} rolled #{roll}"
end

bot.run