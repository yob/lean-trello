require "clamp"
require "trello"

module LeanTrello
  module CLI

    class MainCommand < Clamp::Command

      option "--api-key", "KEY", "Trello API key", environment_variable: "TRELLO_API_KEY", required: true
      option "--token", "TOKEN", "Trello API Token", environment_variable: "TRELLO_API_TOKEN", required: true

      subcommand ["label-count"], "Display a count of labels in each list" do

        parameter "board-id", "trello board ID"

        def execute
          client.find( :boards, board_id ).lists.each do |list|
            puts "#{list.name} #{count_labels_in_list(list)}"
          end
        end

      end

			private

      def count_labels_in_list(list)
        counts = Hash.new(0)
        list.cards.each do |card|
          card.labels.each do |label|
            counts[label.name] += 1
          end
        end
        counts
      end

			def client
        @client ||= Trello::Client.new(
          developer_public_key: api_key,
          member_token: token,
        )
      end
    end
  end
end
