defmodule Day4 do
  def parse_input(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  def part1(grid) do
    h = count_horizontal(grid)

    v = grid
    |> transpose()
    |> count_horizontal()

    d = count_diagonal(grid)

    h + v + d
  end
  def part2(grid) do
    windows(grid, 3)
    |> Enum.map(fn window ->
        at = fn x, y -> Enum.at(Enum.at(window, y), x) end
        (
          at.(0, 0) == ?M and
          at.(2, 0) == ?M and
          at.(1, 1) == ?A and
          at.(0, 2) == ?S and
          at.(2, 2) == ?S
        ) or
        (
          at.(0, 0) == ?S and
          at.(2, 0) == ?S and
          at.(1, 1) == ?A and
          at.(0, 2) == ?M and
          at.(2, 2) == ?M
        ) or
        (
          at.(0, 0) == ?M and
          at.(2, 0) == ?S and
          at.(1, 1) == ?A and
          at.(0, 2) == ?M and
          at.(2, 2) == ?S
        ) or
        (
          at.(0, 0) == ?S and
          at.(2, 0) == ?M and
          at.(1, 1) == ?A and
          at.(0, 2) == ?S and
          at.(2, 2) == ?M
        )
      end)
    |> Enum.count(&(&1))
  end

  def transpose(grid) do
    grid
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp count_horizontal(grid) do 
      grid
      |> Enum.map(fn line ->
        Enum.chunk_every(line, 4, 1, :discard)
        |> Enum.count(fn chunk -> chunk == ~c"XMAS" or chunk == ~c"SAMX" end)
      end)
      |> Enum.sum()
  end

  defp count_diagonal(grid) do
    # Count diagonal by sliding a 4x4 window and checking the diagonals of the window
    forward = windows(grid, 4)
    |> Enum.map(fn window ->
        Enum.map(0..3, fn i ->
          Enum.at(Enum.at(window, i), 3-i)
        end)
      end)
    |> Enum.count(fn chunk -> chunk == ~c"XMAS" or chunk == ~c"SAMX" end)

    backward = windows(grid, 4)
    |>Enum.map(fn window ->
        Enum.map(0..3, fn i ->
          Enum.at(Enum.at(window, i), i)
        end)
      end)
    |> Enum.count(fn chunk -> chunk == ~c"XMAS" or chunk == ~c"SAMX" end)

    forward + backward
  end

  defp windows(grid, size) do
    grid
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, r} ->
      row
      |> Enum.with_index()
      |> Enum.filter(fn {_, c} -> r + size <= length(grid) && c + size <= length(row) end)
      |> Enum.map(fn {_, c} -> 
        Enum.map(r..(r + size - 1), fn i ->
          Enum.slice(Enum.at(grid, i), c, size)
        end)
      end)
    end)
  end
end

grid = Day4.parse_input("inputs/day4.txt")

ans1 = Day4.part1(grid)
IO.puts("Part 1: #{ans1}")

ans2 = Day4.part2(grid)
IO.puts("Part 2: #{ans2}")

