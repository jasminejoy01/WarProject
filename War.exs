defmodule War do
  @moduledoc """
    Documentation for `War`.
  """

  @doc """
    Function stub for deal/1 is given below. Feel free to add 
    as many additional helper functions as you want. 

    The tests for the deal function can be found in test/war_test.exs. 
    You can add your five test cases to this file.

    Run the tester by executing 'mix test' from the war directory 
    (the one containing mix.exs)
  """

  ### This is used to sort the collected cards in descending order. in this code, is it applied to new_array
  def reverse_sort(list) do
    Enum.reverse(Enum.sort(list, &>=/2))
  end

   ### Splits the deck into two sets for 2 players.
  def split_alternatively(list) do 
    split_alternatively(list, [], [])
  end

  def split_alternatively([], list1, list2), do: {list1, list2}
  def split_alternatively([elem | rest], list1, list2) do
    {new_list1, new_list2} =
      if rem(length(list1) + length(list2), 2) == 0 do
        {list1 ++ [elem], list2}
      else
        {list1, list2 ++ [elem]}
      end

    split_alternatively(rest, new_list1, new_list2)
  end

  ### pullCards is the gmae itself - takes 2 arrays, the first hand, second hand, and an empty list. The empty list is used to store collected cards, utilized when both players have cards of teh same rank
  ### Logic is broken down into 3 components:
  ### CASE 1. length of both hands are more than 3
  ### CASE 2. one of the decks becomes 0
  ### CASE 3. length of one of the decks is less than or equal to 3
  def pullCards(first, second, new_array) do 
    ### CASE 1: the deck with higher rank takes the cards. when both ranks are the same, the new_array holds the first 2 cards from both decks until the 3rd card is compared. 
    if length(first) > 3 and length(second) > 3 do
        [head1 | tail1] = first
        [head2 | tail2] = second
        if head1 < head2 do
          new_array = Enum.reverse(Enum.sort(new_array ++ [head1, head2]))
          pullCards(tail1, tail2 ++ new_array, [])
        else
          if head1 > head2 do
            new_array = Enum.reverse(Enum.sort(new_array ++ [head1, head2]))
            pullCards(tail1 ++ new_array, tail2, [])
          else
            [head3 | tail3] = tail1
            [head4 | tail4] = tail2
            new_array = Enum.reverse(Enum.sort(new_array ++ [head1, head2, head3, head4]))
            pullCards(tail3, tail4, new_array)
          end
        end
    else
      
      ### CASE 2. : recursion exit case the non-empty set is returned, before the return, all the 14s are converted to 1s
      if length(first) == 0 or length(second) == 0 do
        #IO.inspect(new_array)
        if Enum.empty?(first) do
            second = second ++ new_array
            Enum.map(second, fn x -> if x == 14, do: 1, else: x end)
        else
            first = first ++ new_array
            Enum.map(first, fn x -> if x == 14, do: 1, else: x end)
        end
      else
        
        ### CASE 3. : two subcases are handled here
        ### 3a: when length of one of decks is <=3, but >1
        ### when length of one of decks is =1 (exit recursion case)
        [head1 | tail1] = first
        [head2 | tail2] = second
        if head1 < head2 do
          new_array = Enum.reverse(Enum.sort(new_array ++ [head1, head2]))
          pullCards(tail1, tail2 ++ new_array, [])
        else
          if head1 > head2 do
            new_array = Enum.reverse(Enum.sort(new_array ++ [head1, head2]))
            pullCards(tail1 ++ new_array, tail2, [])
          else
            if length(first) == 1 or length(second) == 1 do
              new_array = Enum.reverse(Enum.sort(new_array ++ [head1, head2]))
              pullCards(tail1, tail2, new_array)
            else 
            [head3 | tail3] = tail1
            [head4 | tail4] = tail2
            new_array = Enum.reverse(Enum.sort(new_array ++ [head1, head2, head3, head4]))
            pullCards(tail3, tail4, new_array)
            end
          end
        end
      end
    end
  end

  ### The set of cards is first reversed, then all the 1s are swapped to 14s (since Ace has highest rank), after which it is 'dealt' alternatively. So deck is split into two. The resulting hands are result1 and result2. The result1 and result2 sets of 26 cards respectively are then used to play the game.
  def deal(shuf) do 
    {result1, result2} = split_alternatively(Enum.map(Enum.reverse(shuf), fn x -> if x == 1, do: 14, else: x end))
    final = pullCards(result1, result2, [])
    final
  end

end

# t20=[1,2,3,4,5,6,7,8,9,10,11,12,1,2,3,4,5,6,7,8,9,10,11,12,1,2,3,4,5,6,7,8,9,10,11,12,1,2,3,4,5,6,7,8,9,10,11,12,13,13,13,13]
# r20=[5,2,9,6,1,6,11,4,10,5,9,3,13,5,11,3,1,4,12,2,7,2,3,2,1,13,13,11,10,10,13,12,12,9,7,4,1,7,10,4,11,5,6,3,12,9,8,8,8,8,7,6]

# IO.puts(War.deal(t20) == r20)