
defmodule Poker do

	# clear && c("Poker.ex") && clear 

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

	# Poker.deal([1,14,13,15,12,16,11,17,10,18])		Result: 1st Hand Wins (using a Royal Flush)
	# Poker.deal([1,14,2,15,3,16,4,17,5,18])			Result: Both Straight Flush
	# Poker.deal([29,42,44,4,5,5,6,45,9,9])				Result: First hand wins w/rank 5S > 4C
	# Poker.deal([29,42,4,44,5,5,6,45,9,9])				Result: Second hand wins w/rank 5S > 4C
	# Poker.deal([1,5,2,4,3,3,4,2,5,1]) 				Result: Identitcal hands 

	# Poker.deal([1,1,2,2,3,3,4,4,5,5])				Result: Seco

	# Makes testing easier:
	# Try: Poker.test_deal(["AC","JC","QC","KC"]) 
	def test_deal(list) do

		# Convert to uppercase "qc" to "QC"
		# FYI: "qc" is a Queen of Clubs
		list = Enum.map(list, fn(elem) ->
			# Convert to uppercase
			_string_representation_of_card = String.upcase(elem)
		end)

		# Convert "QC" to "12C"
		list = Enum.map(list, fn(uppercase_card) ->
			# Retrieve the rank of the card
			rank_string = String.at(uppercase_card, 0)
			# Retrieve the suit of the card
			suit = String.at(uppercase_card, 1)
			# Replace "A", "J", "Q" and "K" to their number representations
			cond do
				rank_string == "A" ->
					number_representation_of_rank = "1"
					"#{number_representation_of_rank}#{suit}"

				rank_string == "J" ->
					number_representation_of_rank = "11"
					"#{number_representation_of_rank}#{suit}"

				rank_string == "Q" ->
					number_representation_of_rank = "12"
					"#{number_representation_of_rank}#{suit}"

				rank_string == "K" ->
					number_representation_of_rank = "13"
					"#{number_representation_of_rank}#{suit}"
			end
		end)

		# Convert "12C" to 12.
		list = Enum.map(list, fn(card) ->
			
			# Retreive the rank (e.g. "12") and suit (i.e. "C") seperately
			list_of_captures = Regex.run(~r/^(\d+)([a-zA-Z]+)/, card)
			# Extract the rank from the list
			rank_string = Enum.at(list_of_captures, 1)
			rank = String.to_integer(rank_string)
			# Extract the suit from the list
			suit_string = Enum.at(list_of_captures, 2)

			# Return the integer representation of the card
			cond do
				suit_string == "C" ->
					rank + 0
				suit_string == "D" ->
					rank + 13
				suit_string == "H" ->
					rank + 26
				suit_string == "S" ->
					rank + 39
			end
		end)
	end

	def deal(list) do
		# Convert each card into the following foramt: {<rank>, <suit>}
		converted_list = convert(list)
		# Retrieve all the cards that should be allocated to the 2nd hand
		second_hand = Enum.drop_every(converted_list, 2) |> sort_by_rank
		# Retrieve all the cards that should be allocated to the 1st hand
		first_hand = (converted_list -- second_hand) |> sort_by_rank

		# Determine the rank of each hand
		{first_hand_rank_category, _} = rank_hand(first_hand)
		{second_hand_rank_category, _} = rank_hand(second_hand)

		# Compare the "rank category" of each hand
		cond do
			# Manage the situtation where: the 1st hand has a higher "rank category"
			first_hand_rank_category < second_hand_rank_category ->
				convert_to_output(first_hand)
			# Manage the situtation where: the 2nd hand has a higher "rank category"
			second_hand_rank_category < first_hand_rank_category ->
				convert_to_output(second_hand)
			# Manage the situtation where: both hands have the same "rank category"
			# e.g. both hands are a Straight Flush
			first_hand_rank_category == second_hand_rank_category ->
				# IO.puts("This case has not been handled.")
				if do_tie_cond(first_hand, second_hand) == true do
					convert_to_output(first_hand)
					#IO.puts("First_hand")
				else 
					if do_tie_cond(first_hand, second_hand) == false do
						convert_to_output(second_hand)
						#IO.puts("Second_hand")
					else
						IO.puts("Identical hands")
					end

				end
		end
	end

  	def do_tie_cond(first, second) do
		combined = Enum.zip(first, second)
		# is false if r1 == r2 or r2 is always less than r1
		rank = Enum.any?(combined,fn {{r1, _s1}, {r2, _s2}} -> r1 > r2 end)
		e1 = Enum.all?(combined,fn {{r1, _s1}, {r2, _s2}} -> r1 == r2 end)
		 if rank == false and e1 == true do
		 	suit = Enum.any?(combined,fn {{_ßr1, s1}, {_r2, s2}} -> s1 > s2 end)
		 	e2 = Enum.all?(combined,fn {{_ßr1, s1}, {_r2, s2}} -> s1 == s2 end)
		 	if suit == false and e2 == true do
		 		nil
		 	else
		 		suit
		 	end 
		 else
		 	rank
		 end
  	end
	#def do_tie_cond(first, second) do
	#	 Enum.zip(first, second) |> Enum.any?(fn {{r1, _s1}, {r2, _s2}} -> r1 < r2 end)
	#end
	# Return a number between 1-10 that dictates the "ranking category" of the given hand.
	# A lower "ranking category" (e.g. 1) is always better than a higher "ranking category" (e.g. 5)
	def rank_hand(hand) do
		cond do
			is_royal_flush?(hand) == true ->
				{1, hand}
			is_straight_flush?(hand) == true ->
				{2, hand}
			is_four_of_a_kind?(hand) == true ->
				{3, hand}
			is_full_house?(hand) == true ->
				{4, hand}
			is_flush?(hand) == true ->
				{5, hand}
			is_straight?(hand) == true ->
				{6, hand}
			is_three_of_a_kind?(hand) == true ->
				{7, hand}
			is_two_pairs?(hand) == true ->
				{8, hand}
			is_one_pair?(hand) == true ->
				{9, hand}
			true == true ->
				{10, hand}
		end
	end

	# Convert hand to output version
	# Poker.convert_to_output([{1, "S"}, {8, "S"}, {11, "S"}, {13, "S"}, {1, "C"}])
	def convert_to_output(hand) do
		# Sort the hand in ascending order
		sorted_hand = sort_by_rank_asc(hand)
		# Convert each Tuple using the following String format: "<rank><suit>"
		output_list = Enum.map(sorted_hand, fn(tup) ->
			{rank, suit} = tup
			# Convert the rank (in the tuple) to a String
			rank_string = Integer.to_string(rank)
			# Use string interpolation to achieve the given format
			"#{rank_string}#{suit}"
		end)
	end


	# Sort the converted list-of-tuples base on their rank - Desc order
	def sort_by_rank(list) do
		Enum.sort(list, fn (a, b) -> 
			{a_rank, _} = a
			{b_rank, _} = b
			a_rank >= b_rank
		 end)
	end

	# Sort the converted list-of-tuples base on their rank - Asc order
	# Poker.sort_by_rank_asc([{1, "S"}, {8, "S"}, {11, "S"}, {13, "S"}, {1, "C"}])
	def sort_by_rank_asc(list) do
		Enum.sort(list, fn (a, b) -> 
			{a_rank, _} = a
			{b_rank, _} = b
			a_rank <= b_rank
		 end)
	end

	# Sort the converted list-of-tuples base on their suit - Asc order
	def sort_by_suit(list) do
		Enum.sort(list, fn (a, b) -> 
			{_, a_suit} = a
			{_, b_suit} = b
			a_suit >= b_suit
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
	end

	# Determine if a given hand is a Royal Flush 
	# Poker.is_royal_flush?([{1, "S"}, {10,"S"}, {11,"S"}, {12,"S"}, {13,"S"}])
	# Poker.is_royal_flush?([{50, "S"}, {49,"S"}, {48,"S"}, {47,"S"}, {45,"S"}])
	def is_royal_flush?(list) do
		type = elem((hd list), 1) 
		Enum.all?(list, fn({_x,y}) -> y == type end) and Enum.any?(list, fn({x,_y}) -> x == 13 end) and
		Enum.any?(list, fn({x,_y}) -> x == 12 end) and Enum.any?(list, fn({x,_y}) -> x == 11 end) and
		Enum.any?(list, fn({x,_y}) -> x == 10 end) and Enum.any?(list, fn({x,_y}) -> x == 1 end)
	end

	# Determine if a given hand is a Straight Flush 
	# Poker.is_straight_flush?([{50, "S"}, {49,"S"}, {48,"S"}, {47,"S"}, {46,"S"}])
	# Poker.is_straight_flush?([{50, "S"}, {49,"S"}, {48,"S"}, {47,"S"}, {45,"S"}])
	def is_straight_flush?(list) do
		type = elem((hd list), 1) 
		rank = elem((hd list), 0)
		Enum.all?(list, fn({_x,y}) -> y == type end) and Enum.any?(list, fn({x,_y}) -> x == rank end) and
		Enum.any?(list, fn({x,_y}) -> x == (rank-1) end) and Enum.any?(list, fn({x,_y}) -> x == (rank-2) end) and
		Enum.any?(list, fn({x,_y}) -> x == (rank-3) end) and Enum.any?(list, fn({x,_y}) -> x == (rank-4) end) 
	end

	# Determine if a given hand is a Four Of A Kind
	# Poker.is_four_of_a_kind?([{1, "C"}, {1, "D"}, {1, "H"}, {1, "S"}, {2, "C"}])
	# Poker.is_four_of_a_kind?([{50, "S"}, {49,"S"}, {48,"S"}, {47,"S"}, {45,"S"}])
	# Poker.is_four_of_a_kind?([{1, "C"}, {2, "D"}, {3, "H"}, {4, "S"}])
	def is_four_of_a_kind?(list) do
		# Determine the number of cards (that exist) for each suit
		cards_per_rank = number_of_cards_per_rank(list)
		# Get a List of the frequency of each suit
		frequency_list = Map.values(cards_per_rank)
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

	# Determine if a given hand is a Straight
	# Poker.is_straight?([{9, "S"}, {8,"C"}, {7,"D"}, {6,"H"}, {5,"S"}])
	def is_straight?(list) do
		rank = elem((hd list), 0)
		Enum.any?(list, fn({x,_y}) -> x == rank end) and
		Enum.any?(list, fn({x,_y}) -> x == (rank-1) end) and Enum.any?(list, fn({x,_y}) -> x == (rank-2) end) and
		Enum.any?(list, fn({x,_y}) -> x == (rank-3) end) and Enum.any?(list, fn({x,_y}) -> x == (rank-4) end) 
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

	# Determine if a given hand is a Pair (i.e. only has one pair of matching-rank cards)
	# Poker.is_one_pair?([{9, "C"}, {9, "D"}, {2, "H"}, {3, "S"}, {4, "C"}])
	# Poker.is_one_pair?([{1, "S"}, {8, "S"}, {11, "S"}, {13, "S"}, {1, "C"}])
	# Poker.is_one_pair?([{50, "S"}, {49,"S"}, {48,"S"}, {47,"S"}, {45,"S"}])
	def is_one_pair?(list) do
		# Determine the number of cards (that exist) for each rank
		cards_per_rank = number_of_cards_per_rank(list)
		# Get a List of the frequency of each rank
		frequency_list = Map.values(cards_per_rank)

		# Store every instance of 2 (in the frequency List)
		two_list = Enum.filter(frequency_list, fn(elem) -> elem == 2 end)
		# Determine the length of the List
		length_of_two_list = Enum.count(two_list)
		# Return true if the length of the List is 2
		length_of_two_list == 1
	end

end
# [1, 2, :a, 2, :a, :b, :a] |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end) |>  Enum.sort()
# Main array passed into function
# 	1) Seperate into two different arrays, evens - odds
#   2) Use map to convert cards in int to string format
#	3)
