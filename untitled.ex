
defmodule Poker do

	@card_map %{
		# Clubs
		1 => {1, "C"},		# Ace
		2 => {2, "C"},
		3 => {3, "C"},
		4 => {4, "C"},
		5 => {5, "C"},
		6 => {6, "C"},
		7 => {7, "C"},
		8 => {8, "C"},
		9 => {9, "C"},
		10 => {10, "C"},
		11 => {11, "C"},	# Jack
		12 => {12, "C"},	# Queen
		13 => {13, "C"},	# King
		# Diamonds
		14 => {1, "D"},		# Ace
		15 => {2, "D"},
		16 => {3, "D"},
		17 => {4, "D"},
		18 => {5, "D"},
		19 => {6, "D"},
		20 => {7, "D"},
		21 => {8, "D"},
		22 => {9, "D"},
		23 => {10, "D"},
		24 => {11, "D"},	# Jack
		25 => {12, "D"},	# Queen
		26 => {13, "D"},	# King
		# Hearts
		27 => {1, "H"},		# Ace
		28 => {2, "H"},
		29 => {3, "H"},
		30 => {4, "H"},
		31 => {5, "H"},
		32 => {6, "H"},
		33 => {7, "H"},
		34 => {8, "H"},
		35 => {9, "H"},
		36 => {10, "H"},
		37 => {11, "H"},	# Jack
		38 => {12, "H"},	# Queen
		39 => {13, "H"},	# King
		# Spades
		40 => {1, "S"},		# Ace
		41 => {2, "S"},
		42 => {3, "S"},
		43 => {4, "S"},
		44 => {5, "S"},
		45 => {6, "S"},
		46 => {7, "S"},
		47 => {8, "S"},
		48 => {9, "S"},
		49 => {10, "S"},
		50 => {11, "S"},	# Jack
		51 => {12, "S"},	# Queen
		52 => {13, "S"},	# King
	}

	# Temporary (for testing purposes)
	def card_map do
		@card_map
	end

	# Poker.deal([1,2,1,41,1,15,1,28,1,52])
	def deal(list) do
		temp = Enum.zip(1..10, list) 
		# @noah – Consider using Enum.drop_every(numerable, nth)
		# See: https://hexdocs.pm/elixir/Enum.html#drop_every/2
		# Ex:
		# second = Enum.drop_every(list, 2)
		# first = list -- second
		second = Enum.filter(temp, fn{x,_y} -> (rem x, 2) == 0 end) |> convert()
		first = Enum.filter(temp, fn{x,_y} -> (rem x, 2) != 0 end) |> convert()
		is_fourofkind(first)
		is_fourofkind(second)
		first
	end

	# Sort the converted list-of-tuples base on their rank
	def sort_by_rank(list) do
		Enum.sort(list, fn (a, b) -> 
			{a_rank, _} = a
			{b_rank, _} = b
			a_rank <= b_rank
		 end)
	end

	# Sort the converted list-of-tuples base on their suit
	def sort_by_suit(list) do
		Enum.sort(list, fn (a, b) -> 
			{_, a_suit} = a
			{_, b_suit} = b
			a_suit <= b_suit
		 end)
	end

	# Returns a Map containing the # of cards per suit; Example: %{"C" => 1, "S" => 4}
	# Poker.number_of_cards_per_suit([{1, "S"}, {8, "S"}, {11, "S"}, {13, "S"}, {1, "C"}])
	# Poker.number_of_cards_per_suit([{50, "S"}, {49,"S"}, {48,"S"}, {47,"S"}, {45,"S"}])
	# Poker.number_of_cards_per_suit([{1, "C"}, {2, "D"}, {3, "H"}, {4, "S"}])
	def number_of_cards_per_suit(list) do
		# Create a List of all of suits in the hand (keep the duplicates)
		suits = Enum.map(list, fn(elem) ->
			{_, suit} = elem
			suit
		end)
		# Create a Map where each key is the suit, 
		# and the value is the number of cards (in the hand) with that suit
		Enum.frequencies(suits)
	end

	# Returns a Map containing the # of cards per rank; Example: %{1 => 2, 8 => 1, 11 => 1, 13 => 1}
	# Poker.number_of_cards_per_suit([{1, "S"}, {8, "S"}, {11, "S"}, {13, "S"}, {1, "C"}])
	# Poker.number_of_cards_per_suit([{50, "S"}, {49,"S"}, {48,"S"}, {47,"S"}, {45,"S"}])
	# Poker.number_of_cards_per_suit([{1, "C"}, {2, "D"}, {3, "H"}, {4, "S"}])
	def number_of_cards_per_rank(list) do
		# Create a List of all of ranks in the hand (keep the duplicates)
		ranks = Enum.map(list, fn(elem) ->
			{rank, _} = elem
			rank
		end)
		# Create a Map where each key is the rank, 
		# and the value is the number of cards (in the hand) with that rank
		Enum.frequencies(ranks)
	end
	
	# Poker.convert([40,47,50,52,1,52,51,50,49,40])
	# Poker.convert([52,51,50,49,40])
	# Poker.convert([1,15,29,43])
	def convert(list) do
		Enum.map(list, fn y -> @card_map[y] end)
		#is_RoyalFlush(result)
	end

	def is_RoyalFlush(list) do
		type = elem((hd list), 1) 
		Enum.all?(list, fn({_x,y}) -> y == type end) and Enum.any?(list, fn({x,_y}) -> x == 13 end) and
		Enum.any?(list, fn({x,_y}) -> x == 12 end) and Enum.any?(list, fn({x,_y}) -> x == 11 end) and
		Enum.any?(list, fn({x,_y}) -> x == 10 end) and Enum.any?(list, fn({x,_y}) -> x == 1 end)
	end

	#  Poker.is_straightFlush([{50, "S"}, {49,"S"}, {48,"S"}, {47,"S"}, {46,"S"}])
	#  Poker.is_straightFlush([{50, "S"}, {49,"S"}, {48,"S"}, {47,"S"}, {45,"S"}])
	def is_straightFlush(list) do
		type = elem((hd list), 1) 
		rank = elem((hd list), 0)
		Enum.all?(list, fn({_x,y}) -> y == type end) and Enum.any?(list, fn({x,_y}) -> x == rank end) and
		Enum.any?(list, fn({x,_y}) -> x == (rank-1) end) and Enum.any?(list, fn({x,_y}) -> x == (rank-2) end) and
		Enum.any?(list, fn({x,_y}) -> x == (rank-3) end) and Enum.any?(list, fn({x,_y}) -> x == (rank-4) end)
	end

	def is_fourofkind(list) do
		 
		Enum.map(list, fn n -> 
			case n do
				{x, _y} -> x
			end
		end) 
		|>  Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end) 
		|>  Enum.any?( fn({_x,y}) -> y == 4 end)
	end

	# Determine if a given hand is a Four Of A Kind
	# Poker.is_four_of_a_kind?([{1, "S"}, {8, "S"}, {11, "S"}, {13, "S"}, {1, "C"}])
	# Poker.is_four_of_a_kind?([{50, "S"}, {49,"S"}, {48,"S"}, {47,"S"}, {45,"S"}])
	# Poker.is_four_of_a_kind?([{1, "C"}, {2, "D"}, {3, "H"}, {4, "S"}])
	def is_four_of_a_kind?(list) do
		# Determine the number of cards (that exist) for each suit
		cards_per_suit = number_of_cards_per_suit(list)
		# Get a List of the frequency of each suit
		frequency_list = Map.values(cards_per_suit)
		# Return true if any suit has a frequency equal to (or greater than) 4
		Enum.any?(frequency_list, fn(elem) -> 
			elem >= 4
		end)
	end

	# Determine if a given hand is a Full House
	# Poker.is_full_house?([{9, "C"}, {9, "D"}, {9, "H"}, {4, "S"}, {4, "C"}])
	# Poker.is_full_house?([{1, "S"}, {8, "S"}, {11, "S"}, {13, "S"}, {1, "C"}])
	# Poker.is_full_house?([{50, "S"}, {49,"S"}, {48,"S"}, {47,"S"}, {45,"S"}])
	def is_full_house?(list) do
		# Determine the number of cards (that exist) for each rank
		frequency_per_rank = number_of_cards_per_rank(list)
		# Get a List containing the frequency of each rank
		frequency_list = Map.values(frequency_per_rank)

		# Return true if one rank has a frequency of 3
		has_three = Enum.any?(frequency_list, fn(elem) -> elem == 3 end)
		# Return true if one rank has a frequency of 2
		has_two = Enum.any?(frequency_list, fn(elem) -> elem == 2 end)
		
		# Return true if both cases are true
		has_three and has_two
	end

	# Determine if a given hand is a Flush
	# Poker.is_flush?([{50, "S"}, {49,"S"}, {48,"S"}, {47,"S"}, {45,"S"}])
	# Poker.is_flush?([{9, "C"}, {9, "D"}, {9, "H"}, {4, "S"}, {4, "C"}])
	# Poker.is_flush?([{1, "S"}, {8, "S"}, {11, "S"}, {13, "S"}, {1, "C"}])
	def is_flush?(list) do
		# Determine the number of cards (that exist) for each rank
		frequency_per_suit = number_of_cards_per_suit(list)
		# Get a List containing the frequency of each suit
		frequency_list = Map.values(frequency_per_suit)

		# Return true if one suit has a frequency of 5
		_has_five = Enum.any?(frequency_list, fn(elem) -> elem == 5 end)
	end

	# Determine if a given hand is a Three Of A Kind
	# Poker.is_three_of_a_kind?([{9, "C"}, {9, "D"}, {9, "H"}, {3, "S"}, {4, "C"}])
	# Poker.is_three_of_a_kind?([{1, "S"}, {8, "S"}, {11, "S"}, {13, "S"}, {1, "C"}])
	# Poker.is_three_of_a_kind?([{50, "S"}, {49,"S"}, {48,"S"}, {47,"S"}, {45,"S"}])
	def is_three_of_a_kind?(list) do
		# Determine the number of cards (that exist) for each rank
		cards_per_rank = number_of_cards_per_rank(list)
		# Get a List of the frequency of each rank
		frequency_list = Map.values(cards_per_rank)
		# Return true if any rank has a frequency of 3
		_has_three = Enum.any?(frequency_list, fn(elem) -> elem == 3 end)
	end

	# Determine if a given hand is a Two Pairs
	# Poker.is_two_pairs?([{9, "C"}, {9, "D"}, {3, "H"}, {3, "S"}, {4, "C"}])
	# Poker.is_two_pairs?([{1, "S"}, {8, "S"}, {11, "S"}, {13, "S"}, {1, "C"}])
	# Poker.is_two_pairs?([{50, "S"}, {49,"S"}, {48,"S"}, {47,"S"}, {45,"S"}])
	def is_two_pairs?(list) do
		# Determine the number of cards (that exist) for each rank
		cards_per_rank = number_of_cards_per_rank(list)
		# Get a List of the frequency of each rank
		frequency_list = Map.values(cards_per_rank)

		# Store every instance of 2 (in the frequency List)
		two_list = Enum.filter(frequency_list, fn(elem) -> elem == 2 end)
		# Determine the length of the List
		length_of_two_list = Enum.count(two_list)
		# Return true if the length of the List is 2
		length_of_two_list == 2
	end



end
# [1, 2, :a, 2, :a, :b, :a] |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end) |>  Enum.sort()
# Main array passed into function
# 	1) Seperate into two different arrays, evens - odds
#   2) Use map to convert cards in int to string format
#	3)