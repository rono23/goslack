class Goslack
  class Slack
    attr_accessor :url, :token, :channel, :username, :icon_url, :icon_emoji

    def initialize(options = {})
      yield(self) if block_given?
    end

    def post(text)
      post_url = @url + '?token=' + @token
      payload = {
        channel: @channel,
        username: @username,
        icon_url: @icon_url,
        icon_emoji: @icon_emoji,
        text: text
      }
      Net::HTTP.post_form(URI(post_url), { payload: payload.to_json })
    end
  end
end
