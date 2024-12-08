defmodule Day5 do
  def parse_rules(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "|")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(&List.to_tuple/1)
  end
  def parse_reports(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, ",")
      |> Enum.map(&String.to_integer/1)
    end)
  end
  def parse_input(file) do
    [rules, reports] = file
    |> File.read!()
    |> String.split("\n\n", trim: true)

    {
      parse_reports(reports),
      parse_rules(rules)
    }
  end

  def valid?([], _) do
    true
  end

  def valid?([{a, b}|tail], indices) do
    case {Map.get(indices, a), Map.get(indices, b)} do
      {ai, bi} when ai < bi -> valid?(tail, indices)
      _ -> false
    end
  end

  def part1(reports, rules) do
    Enum.map(reports, fn report ->
        numbers = MapSet.new(report)

        # Filter out relevant rules
        rules = Enum.filter(rules, fn {a, b} ->
          MapSet.member?(numbers, a) and MapSet.member?(numbers, b)
        end)

        # Map of number -> position
        indices = report
        |> Enum.with_index()
        |> Map.new()


        {
          valid?(rules, indices),
          Enum.at(report, Integer.floor_div(length(report), 2))
        }
      end)
    |> Enum.reduce(0, fn
      {true, n}, acc -> acc + n
      {false, _}, acc -> acc
    end)
  end

end

{reports, rules} = Day5.parse_input("inputs/day5.txt")

ans1 = Day5.part1(reports, rules)
IO.puts("Part 1: #{ans1}")

