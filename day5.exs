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

  def topologicalSort(rules) do
    # Does topological sorting, assuming rules are a DAG

    adjacency = Enum.reduce(rules, %{}, fn {a, b}, acc ->
      Map.update(acc, a, [b], fn x -> [b | x] end)
      |> Map.put_new(b, [])
    end)

    nodes = Map.keys(adjacency)

    # DFS
    Enum.reduce(nodes, {MapSet.new(), []}, fn node, {visited, sorted} ->
      visit(node, adjacency, visited, sorted)
    end)
    |> elem(1)
  end

  def visit(node, adjancency, visited, sorted) do
    cond do
      MapSet.member?(visited, node) -> {visited, sorted}
      true ->
        visited = MapSet.put(visited, node)
        {visited, sorted} = Enum.reduce(Map.get(adjancency, node), {visited, sorted},
          fn neighbor, {visited, sorted} ->
            visit(neighbor, adjancency, visited, sorted)
          end
        )
        {visited, [node | sorted]}
    end
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

  def part2(reports, rules) do
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
          report,
        }
      end)
    |> Enum.filter(fn {valid, _} -> !valid end)
    |> Enum.map(&(elem(&1, 1)))
    |> Enum.map(fn report ->
        numbers = MapSet.new(report)

        # Filter out relevant rules
        rules = Enum.filter(rules, fn {a, b} ->
          MapSet.member?(numbers, a) and MapSet.member?(numbers, b)
        end)

        topologicalSort(rules)
        |> Enum.at(Integer.floor_div(length(report), 2))
      end)
    |> Enum.reduce(0, fn
      n, acc -> acc + n
    end)
  end

end

{reports, rules} = Day5.parse_input("inputs/day5.txt")

ans1 = Day5.part1(reports, rules)
IO.puts("Part 1: #{ans1}")

ans2 = Day5.part2(reports, rules)
IO.puts("Part 2: #{ans2}")

