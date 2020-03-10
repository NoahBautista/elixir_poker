# Both Full Houses
a = Poker.deal([8,9,21,22,34,35,4,1,17,2])
IO.puts(a)
# Both Four Of A Kinds
b = Poker.test_deal(["2C","3C","2D","3D","2H","3H","2S","3S","KS","QS"])
IO.puts(b)
# Both Two Pairs
c = Poker.test_deal(["10D","5C","10S","5S","2S","4D","2C","4H","KC","10H"])
IO.puts(c)
# Both One Pairs
d = Poker.test_deal(["JD","JC","JS","JS","AS","AD","9C","8H","3C","7H"])
IO.puts(d)
# Both High Cards
e = Poker.test_deal(["KS","QS","6C","JD","5H","6C","3D","5H","2C","3C"])
IO.puts(e)