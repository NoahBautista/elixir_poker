
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
		# @noah – Consider using Enum.drop_every(numerable, nth)
		# See: https://hexdocs.pm/elixir/Enum.html#drop_every/2
		# Ex:
		# second = Enum.drop_every(list, 2)
		# first = list -- second
		second = Enum.filter(temp, fn{x,_y} -> (rem x, 2) == 0 end) |> convert()
		first = Enum.filter(temp, fn{x,_y} -> (rem x, 2) != 0 end) |> convert()
		is_fourofkind(first)
		is_fourofkind(second)
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

	# Returns a Map containing the # of cards per suit; Example: %{"C" => 1, "S" => 4}
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
end
# [1, 2, :a, 2, :a, :b, :a] |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end) |>  Enum.sort()
# Main array passed into function
# 	1) Seperate into two different arrays, evens - odds
#   2) Use map to convert cards in int to string format
#	3)