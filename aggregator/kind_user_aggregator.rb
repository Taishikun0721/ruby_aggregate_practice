class KindUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    stamp_count = channel_names.map do |channel|
      data = load(channel)
      reactions = data.dig('messages').flat_map { |message| message.dig('reactions', 0, 'users') }.compact
      reactions.group_by(&:itself).map { |key, value| [key, value.count] }.to_h
    end
    stamp_count = {}.merge(*stamp_count).sort_by { |key, value| value }.to_h
    stamp_count.map { |key, value| { user_id: key, reaction_count: value } }.reverse
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end