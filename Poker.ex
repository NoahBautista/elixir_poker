# Ishak Ahmed - 500576186
# Noah Bautista - 500817100

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

	# Poker.deal([1,14,13,15,12,16,11,17,10,18])		Result: 1st Hand Wins (using a Royal Flush)
	# Poker.deal([1,14,2,15,3,16,4,17,5,18])			Result: Both Straight Flush
	# Poker.deal([29,42,44,4,5,5,6,45,9,9])				Result: First hand wins w/rank 5S > 4C
	# Poker.deal([29,42,4,44,5,5,6,45,9,9])				Result: Second hand wins w/rank 5S > 4C
	# Poker.deal([1,5,2,4,3,3,4,2,5,1]) 				Result: Identitcal hands 

	# Makes testing easier:
	# Try: Poker.test_deal(["AC","JC","QC","KC" ...... ]) 
	def test_deal(list) do
		# Call the 'simplify_deal' function
		list = simplify_deal(list)
		# Call the 'deal' function
		deal(list)
	end

	# Converts the simplified input to a List of integers 
	# Try: Poker.simplify_deal(["AC","JC","QC","KC" ...... ]) 
	def simplify_deal(list) do
		# Convert to uppercase "qc" to "QC"
		# FYI: "qc" is a Queen of Clubs
		list = Enum.map(list, fn(elem) ->
			# Convert to uppercase
			_string_representation_of_card = String.upcase(elem)
		end)

		# Convert "QC" to "12C"
		list = Enum.map(list, fn(uppercase_card) ->
			# Retreive the rank (e.g. "12") and suit (i.e. "C") seperately
			list_of_captures = Regex.run(~r/^([A\dJQK]+)([a-zA-Z]+)/, uppercase_card)
			# Extract the rank from the list
			rank_string = Enum.at(list_of_captures, 1)
			# Extract the suit from the list
			suit = Enum.at(list_of_captures, 2)

			# Replace "A", "J", "Q" and "K" to their number representations
			cond do
				# Manage the situation where: the rank is an "A" (Ace)
				rank_string == "A" ->
					number_representation_of_rank = "1"
					"#{number_representation_of_rank}#{suit}"

				# Manage the situation where: the rank is an "J" (Jack)
				rank_string == "J" ->
					number_representation_of_rank = "11"
					"#{number_representation_of_rank}#{suit}"

				# Manage the situation where: the rank is an "Q" (Queen)
				rank_string == "Q" ->
					number_representation_of_rank = "12"
					"#{number_representation_of_rank}#{suit}"

				# Manage the situation where: the rank is an "K" (King)
				rank_string == "K" ->
					number_representation_of_rank = "13"
					"#{number_representation_of_rank}#{suit}"

				# Manage the situation where: the rank a number between (and including) 2 and 10
				2 <= String.to_integer(rank_string) and String.to_integer(rank_string) <= 10 -> 
					"#{rank_string}#{suit}"
			end
		end)

		# Convert "12C" to 12.
		_list = Enum.map(list, fn(card) ->
			
			# Retreive the rank (e.g. "12") and suit (i.e. "C") seperately
			list_of_captures = Regex.run(~r/^([A\dJQK]+)([a-zA-Z]+)/, card)
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
				# Determine the course of action based on the "rank category" 
				# (of either hand since they are the same)
				cond do
					# Manage the situation where: both hands are a Four Of A Kind
					first_hand_rank_category == 3 ->
						result = tie_four_of_kind(first_hand, second_hand)
						result(first_hand, second_hand, result)

					# Manage the situation where: both hands are either (1) Full House or (2) Three Of A Kind
					first_hand_rank_category == 4 || first_hand_rank_category == 7 ->
						result = tie_full_house(first_hand, second_hand)
						result(first_hand, second_hand, result)

					# Manage the situation where: both hands are a Two Pairs
					first_hand_rank_category == 8 ->
						result = tie_two_pairs(first_hand, second_hand)
						result(first_hand, second_hand, result)

					# Manage the situation where: both hands are a Pair
					first_hand_rank_category == 9 ->
						result = tie_one_pair(first_hand, second_hand)
						result(first_hand, second_hand, result)

					# Manage the situation where: both hands are a High Card
					first_hand_rank_category == 10 ->
						result = do_tie_cond(first_hand, second_hand)
						result(first_hand, second_hand, result)

					# Manage the situation where: both hands are either 
					# (1) Straight Flush (2) Flush (3) Straight
					first_hand_rank_category == 2 || first_hand_rank_category == 5 || first_hand_rank_category == 6 ->
						result = do_tie_cond(first_hand, second_hand)
						result(first_hand, second_hand, result)
				end

			# Manage the impossible situation where: first_hand_rank_category is none of the above
			true ->
				IO.puts("This is impossible.")
		end
	end

	def result(first, second, result) do
		if result == true do
			convert_to_output(first)
		else 
			if result == false do
				convert_to_output(second)
			else
				IO.puts("Identical hands")
			end
		end
	end

	#Poker.deal([8,9,21,22,34,35,4,1,17,2]) 	Result: First wins as full house > three of a kind
	#Poker.deal([1,2,14,15,27,28,5,1,18,14])	Result:
	def tie_full_house(first,second) do

		_f1 = number_of_cards_per_rank(first) |> Enum.filter(fn({_rank, freq}) -> freq == 3 end) |> Enum.map(fn {rank, _freq} -> rank end)
		_f2 = number_of_cards_per_rank(second) |> Enum.filter(fn({_rank, freq}) -> freq == 3 end) |> Enum.map(fn {rank, _freq} -> rank end)
		l1 =  Enum.zip(first, second) |> Enum.all?(fn {x,y} -> x > y end)
		if l1 == true do
			l1
		else
			if l1 == false do
				l1
			else
				nil
			end
		end
	end

	# Poker.test_deal(["2C","3C","2D","3D","2H","3H","2S","3S","KS","QS"])
	def tie_four_of_kind(first, second) do

		first = number_of_cards_per_rank(first) |> Enum.filter(fn({_rank, freq}) -> freq == 4 end) |> Enum.map(fn {rank, _freq} -> rank end)
		second = number_of_cards_per_rank(second) |> Enum.filter(fn({_rank, freq}) -> freq == 4 end) |> Enum.map(fn {rank, _freq} -> rank end)
		l1 =  Enum.zip(first, second) |> Enum.any?(fn {x,y} -> x > y end)
		if l1 == true do
			l1
		else
			if l1 == false do
				l1
			else
				nil
			end
		end
	end


	# Poker.test_deal(["10D","5C","10S","5S","2S","4D","2C","4H","KC","10H"])
	def tie_two_pairs(first, second) do

		first = number_of_cards_per_rank(first) |> Enum.filter(fn({_rank, freq}) -> freq == 2 end) |> sort_by_rank
		second = number_of_cards_per_rank(second) |> Enum.filter(fn({_rank, freq}) -> freq == 2 end) |> sort_by_rank

		# Retrieve the 1st highest rank of the first hand
		{first_highest_rank_of_the_first_hand, _} = Enum.fetch(first, 0) |> elem(1)
		# Retrieve the 1st highest rank of the second hand
		{first_highest_rank_of_the_second_hand, _} = Enum.fetch(second, 0) |> elem(1)

		# Determine which hand is the highest (by comparing the 1st highest ranking pair)
		cond do
			# Manage the situation where: the first hand has a higher ranking pair
			first_highest_rank_of_the_first_hand > first_highest_rank_of_the_second_hand ->
				true
			# Manage the situation where: the second hand has a higher ranking pair
			first_highest_rank_of_the_first_hand < first_highest_rank_of_the_second_hand ->
				false
			# Manage the situation where: the first and second hand's highest pair are equivalent
			first_highest_rank_of_the_first_hand == first_highest_rank_of_the_second_hand ->
				# Retrieve the 2nd highest rank of the first hand
				{second_highest_rank_of_the_first_hand, _} = Enum.fetch(first, 1) |> elem(1)
				# Retrieve the 2nd highest rank of the second hand
				{second_highest_rank_of_the_second_hand, _} = Enum.fetch(second, 1) |> elem(1)

				# Determine which hand is the highest (by comparing the 2nd highest pair in each hand)
				cond do
					# Manage the situation where: the first hand has a higher ranking pair
					second_highest_rank_of_the_first_hand > second_highest_rank_of_the_second_hand ->
						true
					# Manage the situation where: the second hand has a higher ranking pair
					second_highest_rank_of_the_first_hand < second_highest_rank_of_the_second_hand ->
						false
					# Manage the situation where: the first and second hand's highest pair are equivalent
					second_highest_rank_of_the_first_hand == second_highest_rank_of_the_second_hand ->
						# Get the rank of the non-pair card in the first hand
						rank_of_nonpair_card_in_first_hand = number_of_cards_per_rank(first) |> Enum.filter(fn({_rank, freq}) -> freq == 1 end) |> Enum.fetch(0) |> elem(1) |> elem(0)
						# Get the rank of the non-pair card in the second hand
						rank_of_nonpair_card_in_second_hand = number_of_cards_per_rank(second) |> Enum.filter(fn({_rank, freq}) -> freq == 1 end) |> Enum.fetch(0) |> elem(1) |> elem(0)

						# Determine which hand is the highest (by comparing the nonpair card in each hand)
						cond do
							# Manage the situation where: the first hand has a higher ranking pair
							rank_of_nonpair_card_in_first_hand > rank_of_nonpair_card_in_second_hand ->
								true
							# Manage the situation where: the second hand has a higher ranking pair
							rank_of_nonpair_card_in_first_hand < rank_of_nonpair_card_in_second_hand ->
								false
						end
				end
		end
	end

	# Poker.test_deal(["JD","JC","JS","JS","AS","AD","9C","8H","3C","7H"])
	def tie_one_pair(first_hand, second_hand) do

		first = number_of_cards_per_rank(first_hand) |> Enum.filter(fn({_rank, freq}) -> freq == 2 end) |> sort_by_rank
		second = number_of_cards_per_rank(second_hand) |> Enum.filter(fn({_rank, freq}) -> freq == 2 end) |> sort_by_rank

		# Retrieve the 1st highest rank of the first hand
		{first_highest_rank_of_the_first_hand, _} = Enum.fetch(first, 0) |> elem(1)
		# Retrieve the 1st highest rank of the second hand
		{first_highest_rank_of_the_second_hand, _} = Enum.fetch(second, 0) |> elem(1)

		# Determine which hand is the highest (by comparing the 1st highest ranking pair)
		cond do
			# Manage the situation where: the first hand has a higher ranking pair
			first_highest_rank_of_the_first_hand > first_highest_rank_of_the_second_hand ->
				true
			# Manage the situation where: the second hand has a higher ranking pair
			first_highest_rank_of_the_first_hand < first_highest_rank_of_the_second_hand ->
				false
			# Manage the situation fwhere: the first and second hand's highest pair are equivalent
			first_highest_rank_of_the_first_hand == first_highest_rank_of_the_second_hand ->
				# Remove the Pair from each hand
				first_hand_without_the_pair = Enum.reject(first_hand, fn({rank, _suit}) -> rank == first_highest_rank_of_the_first_hand end)
				second_hand_without_the_pair = Enum.reject(second_hand, fn({rank, _suit}) -> rank == first_highest_rank_of_the_second_hand end)
				do_tie_cond(first_hand_without_the_pair, second_hand_without_the_pair)
		end

	end


  	# Poker.test_deal(["KS","QS","6C","JD","5H","6C","3D","5H","2C","3C"])
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
			true ->
				{10, hand}
		end
	end

	# Convert hand to output version
	# Poker.convert_to_output([{1, "S"}, {8, "S"}, {11, "S"}, {13, "S"}, {1, "C"}])
	def convert_to_output(hand) do
		# Sort the hand in ascending order
		sorted_hand = sort_by_rank_asc(hand)
		# Convert each Tuple using the following String format: "<rank><suit>"
		_output_list = Enum.map(sorted_hand, fn(tup) ->
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
