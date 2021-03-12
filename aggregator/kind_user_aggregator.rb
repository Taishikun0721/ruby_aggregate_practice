class KindUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    channel_names.map do |channel|
      data = load(channel)
      reactions = data.dig('messages').flat_map { |message| message.dig('reactions', 0, 'users') }.compact
      stamp_count = reactions.group_by(&:itself).map { |key, value| [key, value.count] }.to_h
      stamp_count.max_by { |key, value| value }
          .then { |key, value| { user_id: key, reaction_count: value } }
    end
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end