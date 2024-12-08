defmodule Day1 do
  def process_line(line) do
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def parse_input(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&process_line/1)
    |> Enum.reduce({[], []}, fn [l, r], {left, right} -> {[l | left], [r | right]} end)
  end

  def part1(left, right) do
    {left, right}
    |> then(fn {left, right} -> {Enum.sort(left), Enum.sort(right)} end)
    # Calculate distances
    |> then(fn {left, right} -> 
      Enum.zip(left, right)
      |> Enum.map(fn {l, r} -> abs(r - l) end)
    # Sum all distances
    |> Enum.sum()
    end)
  end
  
  def part2(left, right) do
    {left, right}
    # Multiply a[i] by freq of a[i] in b
    |> then(fn {left, right} ->
      freq = Enum.frequencies(right)
      Enum.map(left, fn x -> x * Map.get(freq, x, 0) end)
    end)
    |> Enum.sum()
  end

end

{left, right} = Day1.parse_input("inputs/day1.txt")

ans1 = Day1.part1(left, right)
IO.puts("Part 1: #{ans1}")

ans2 = Day1.part2(left, right)
IO.puts("Part 2: #{ans2}")



