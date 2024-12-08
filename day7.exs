defmodule Day7 do
  defp process_line(line) do
    line
    |> String.split(":")
    |> then(fn [sum, list] ->
      {
        String.to_integer(sum),
        list
        |> String.split()
        |> Enum.map(&String.to_integer/1)
      }
    end)
  end

  def parse_input(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&process_line/1)
  end

  defp valid?(sum, acc, []) do
    acc == sum
  end

  defp valid?(sum, acc, [head|tail]) do
    cond do
      acc > sum -> false
      true -> 
        valid?(sum, acc + head, tail) or 
        valid?(sum, acc * head, tail)
    end
  end

  defp valid2?(sum, acc, []) do
    acc == sum
  end

  defp valid2?(sum, acc, [head|tail]) do
    cond do
      acc > sum -> false
      true -> 
        valid2?(sum, acc + head, tail) or 
        valid2?(sum, acc * head, tail) or
        valid2?(sum, merge(acc, head), tail)
    end
  end

  defp merge(a, b) do
    a * :math.pow(10, (:math.floor(:math.log10(b))+1)) + b
  end

  def part1(input) do
    Enum.map(input, fn {sum, list} -> {sum, valid?(sum, 0, list)} end)
    |> Enum.filter(fn {_, valid} -> valid end)
    |> Enum.map(fn {sum, _} -> sum end)
    |> Enum.sum()
  end

  def part2(input) do
    Enum.map(input, fn {sum, list} -> {sum, valid2?(sum, 0, list)} end)
    |> Enum.filter(fn {_, valid} -> valid end)
    |> Enum.map(fn {sum, _} -> sum end)
    |> Enum.sum()
  end
end

input = Day7.parse_input("inputs/day7.txt")

ans1 = Day7.part1(input)
IO.puts("Part 1: #{ans1}")

ans2 = Day7.part2(input)
IO.puts("Part 2: #{ans2}")



