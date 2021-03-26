class KindUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    stamp_counts = channel_names.map do |channel|
      data = load(channel)
      reactions = data.dig('messages').map { |message| message.dig('reactions') }
      reactions.compact!.flatten!
      stamp_count = reactions.map { |reaction| reaction.dig('users') }.flatten
      stamp_count.group_by(&:itself).map { |key, value| [key, value.count]}.to_h
    end
    {}.merge(*stamp_counts) { |_ , value, next_value| value + next_value }
        .max_by(3) { |_, value| value }
        .map { |key, value| { user_id: key, reaction_count: value } }
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end