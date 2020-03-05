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
	
	def deal([]), do: raise ArgumentError, message: "the argument value is invalid"

	# Sort the converted list-of-tuples base on their rank
	def sort_by_rank do
		# TODO - Ishak will do this ...
	end
	
	# Poker.convert([40,47,50,52,1])
	# Poker.convert([52,51,50,49,40])
	def convert(list) do
		result = Enum.map(list, fn n -> Map.fetch(@card_map, n) end) |>
		Enum.map(fn n ->
		  case n do
		  	{_,y} -> y
		  end
		end)
		is_RoyalFlush(result)
	end

	def is_RoyalFlush(list) do
		type = elem((hd list), 1) 
		Enum.all?(list, fn({_x,y}) -> y == type end) and Enum.any?(list, fn({x,_y}) -> x == 13 end) and
		Enum.any?(list, fn({x,_y}) -> x == 12 end) and Enum.any?(list, fn({x,_y}) -> x == 11 end) and
		Enum.any?(list, fn({x,_y}) -> x == 10 end) and Enum.any?(list, fn({x,_y}) -> x == 1 end)
	end
end

# Main array passed into function
# 	1) Seperate into two different arrays, evens - odds
#   2) Use map to convert cards in int to string format
#	3)