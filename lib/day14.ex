defmodule Day14 do
  @seconds 100
  @m 101
  @n 103
  @x_mid div(@m, 2)
  @y_mid div(@n, 2)

  def process_part_one() do
    input = File.read!("assets/input14.txt")

    ~r/p=(\d+),(\d+) v=(-?\d+),(-?\d+)/
    |> Regex.scan(input)
    |> Enum.map(fn [_, x, y, vx, vy] ->
      {{String.to_integer(x), String.to_integer(y)},
       {String.to_integer(vx), String.to_integer(vy)}}
    end)
    |> Enum.map(fn {{x, y}, {vx, vy}} ->
      x = @seconds * vx + x
      y = @seconds * vy + y

      {normalize_x(x), normalize_y(y)}
    end)
    |> Enum.reject(fn {x, y} -> x == @x_mid or y == @y_mid end)
    |> Enum.group_by(fn {x, y} ->
      cond do
        x < @x_mid and y < @y_mid -> 1
        x > @x_mid and y < @y_mid -> 2
        x > @x_mid and y > @y_mid -> 3
        x < @x_mid and y > @y_mid -> 4
      end
    end)
    |> Enum.map(fn {_, robots} -> Enum.count(robots) end)
    |> Enum.product()
  end

  def process_part_two() do
    input = File.read!("assets/input14.txt")

    ~r/p=(\d+),(\d+) v=(-?\d+),(-?\d+)/
    |> Regex.scan(input)
    |> Enum.map(fn [_, x, y, vx, vy] ->
      {{String.to_integer(x), String.to_integer(y)},
       {String.to_integer(vx), String.to_integer(vy)}}
    end)
    |> animate(0)
  end

  defp animate(robots, s) do
    if looks_valid(robots) do
      IO.puts("Second: #{s}")
      print_robots(robots)
      :timer.sleep(div(1000, 5))
    end

    robots = move(robots)
    animate(robots, s + 1)
  end

  defp move(robots) do
    Enum.map(robots, fn {pos, vel} ->
      {x, y} = pos
      {vx, vy} = vel
      x = vx + x
      y = vy + y
      {{normalize_x(x), normalize_y(y)}, vel}
    end)
  end

  defp looks_valid(robots) do
    robots
    |> Enum.group_by(fn {{x, _}, _} -> x end)
    |> Enum.any?(fn {_, row} -> Enum.count(row) > 20 end)
  end

  defp print_robots(robots) do
    grid =
      for y <- 0..(@n - 1), x <- 0..(@m - 1), into: %{} do
        {{x, y}, "_"}
      end

    grid =
      Enum.reduce(robots, grid, fn {pos, _}, acc ->
        Map.put(acc, pos, "O")
      end)

    for y <- 0..(@n - 1) do
      row =
        for x <- 0..(@m - 1) do
          grid[{x, y}]
        end
        |> Enum.join("")

      IO.puts(row)
    end

    IO.puts("")
  end

  defp normalize_x(x) do
    case rem(x, @m) do
      x when x < 0 -> @m + x
      x -> x
    end
  end

  defp normalize_y(y) do
    case rem(y, @n) do
      y when y < 0 -> @n + y
      y -> y
    end
  end
end
