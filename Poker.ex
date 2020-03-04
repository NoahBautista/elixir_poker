def module Poker do
	def deal([]), do: raise ArgumentError, message: "the argument value is invalid"
	def deal(hd list) do:
		if (length(list) + 1) == 10 do

end

# Main array passed into function
# 	1) Seperate into two different arrays, evens - odds
#   2) Use map to convert cards in int to string format
#	3)