defmodule Poker do
	# def deal([]), do: raise ArgumentError, message: "the argument value is invalid"
	# def deal(hd list) do:
	#	if (length(list) + 1) == 10 do

	# tuple = Map.fetch(map, :a)
	# tuple = {:ok, :example}
	def convert(list) do:
		Enum.each(list, fn n ->
			case n do
				#[{x,y}] ->IO.puts "#{x*y} #{x} #{y}"
				n1 = n
			    n2 = Map.fetch(map, :n)
			    n = {:n1 :n2}
			end
		end)
		Enum.each(list, fn n ->
			case n do
				[{x,y}] ->IO.puts "#{x*y} #{x} #{y}"
			end
		end)
	end

	#def isRoyalFlush(hd list) do:
	#	Enum.each(list, fn n ->
	#	  case n do
		    # [{x,y}] ->IO.puts "#{x*y} #{x} #{y}"
	#	    if()
	#	  end

# Main array passed into function
# 	1) Seperate into two different arrays, evens - odds
#   2) Use map to convert cards in int to string format
#	3)

[{5,2}, {10,2}, {4,5}, {6,5}, {3,10}, {2,15}] |>                                                          
Enum.group_by(fn {a, b} -> a * b end) |>                                                                  
Enum.each(fn {prod, values} ->
	IO.puts(["#{prod} " | Enum.map(values, fn {a, b} -> "#{a} #{b} " end)])
end)