defmodule Day2 do
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
  end
  
  def safe?(list, allowed_fails) do
    safe?(list, [], nil, allowed_fails)
  end

  def safe?([_head | []], _, _, _) do
    true
  end

  def safe?([head | tail], prev_values, prev_sign, allowed_fails) do
    diff = hd(tail) - head
    sign = diff >= 0
    
    c = case prev_sign do
      # First step
      nil -> 0 < abs(diff) and abs(diff) <= 3
      _ -> prev_sign == sign and 0 < abs(diff) and abs(diff) <= 3 
    end

    cond do
      c -> safe?(tail, [head | prev_values], sign, allowed_fails)
      allowed_fails > 0 -> (
        # Try with current value removed
        case prev_values do
          [prev_head | prev_tail] ->
            safe?([prev_head | tail], prev_tail, (hd(tail) - prev_head) >= 0, allowed_fails-1)
          _ -> # First value
            safe?(tail, [], nil, allowed_fails-1)
        end
        or
        # Try with next value removed
        case tail do
            [_] -> # Last value
              true
            [_ | new_tail] ->
              safe?([head | new_tail], [head | prev_values], (hd(new_tail) - head) >= 0, allowed_fails-1) 
        end
      )
      true -> false
    end
  end

  def part1(input) do
    input
    |> Enum.map(fn line ->
      line
      |>safe?(0)
    end)
    |>Enum.count(&(&1))
  end

  def part2(input) do
    input
    |> Enum.map(fn line ->
      line
      |>safe?(1)
    end)
    |>Enum.count(&(&1))
  end
  

end

input = Day2.parse_input("inputs/day2.txt")

ans1 = Day2.part1(input)
IO.puts("Part 1: #{ans1}")

ans2 = Day2.part2(input)
IO.puts("Part 2: #{ans2}")
