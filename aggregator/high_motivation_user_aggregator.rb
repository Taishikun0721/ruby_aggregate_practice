class HighMotivationUserAggregator
  attr_accessor :channel_names
  POST_RANKING = 3

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    channels = []
    channel_names.each do |channel|
      data = load(channel)
      channels << { channel_name: channel, message_count: data.dig('messages').size }
    end
    channels.max_by(POST_RANKING) {|channel| channel[:message_count] }
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end