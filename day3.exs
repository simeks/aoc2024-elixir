defmodule Day3 do
  def part1(input) do
    Regex.scan(~r/mul\((\d+),(\d+)\)/, input)
    |> Enum.map(fn [_, a, b] ->
        String.to_integer(a) * String.to_integer(b)
      end)
    |> Enum.sum()
  end
  def part2(input) do
    Regex.scan(~r/mul\((\d+),(\d+)\)|do\(\)|don't\(\)/, input)
    |> Enum.map(fn op ->
        case op do
          ["do()"] -> :do
          ["don't()"] -> :dont
          [_, a, b] -> {:mul, String.to_integer(a), String.to_integer(b)}
        end
      end)
    |> Enum.reduce({true, 0}, fn
      :do, {_, sum} -> {true, sum}
      :dont, {_, sum} -> {false, sum}
      {:mul, a, b}, {true, sum} -> {true, sum + a * b}
      {:mul, _, _}, {false, sum} -> {false, sum}
    end)
    |> elem(1)
  end
end

input = File.read!("inputs/day3.txt")

ans1 = Day3.part1(input)
IO.puts("Part 1: #{ans1}")

ans2 = Day3.part2(input)
IO.puts("Part 2: #{ans2}")
