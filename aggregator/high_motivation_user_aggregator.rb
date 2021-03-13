class HighMotivationUserAggregator
  attr_accessor :channel_names
  RANKING_LIMIT = 3

  def initialize(channel_names, options = {} )
    @channel_names = channel_names
    @ranking_limit = options[:ranking_limit] || RANKING_LIMIT
  end
  # 実装してください
  def exec
    channels = channel_names.map do |channel|
      data = load(channel)
      { channel_name: channel, message_count: data.dig('messages').size }
    end
    channels.max_by(RANKING_LIMIT) {|channel| channel[:message_count] }
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end