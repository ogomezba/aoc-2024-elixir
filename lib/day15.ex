defmodule Day15 do
  @up {-1, 0}
  @down {1, 0}
  @right {0, 1}
  @left {0, -1}

  def process_part_one() do
    parse_input()
    |> simulate()
    |> calculate_score()
  end

  def process_part_two() do
    parse_input_part_two()
    |> simulate()
    |> calculate_score()
  end

  defp calculate_score(map) do
    map
    |> Map.filter(fn {_coords, value} -> value in ["O", "["] end)
    |> Enum.map(fn {{m, n}, _value} -> 100 * m + n end)
    |> Enum.sum()
  end

  defp simulate({map, instructions}) do
    {x0, _} = Enum.find(map, fn {_, value} -> value == "@" end)
    do_simulate(x0, map, instructions)
  end

  defp do_simulate(_, map, ""), do: map

  defp do_simulate(x, map, instructions) do
    {{map, x}, rest} =
      case instructions do
        "^" <> rest -> {move_robot(x, @up, map), rest}
        ">" <> rest -> {move_robot(x, @right, map), rest}
        "v" <> rest -> {move_robot(x, @down, map), rest}
        "<" <> rest -> {move_robot(x, @left, map), rest}
        "\n" <> rest -> {{map, x}, rest}
      end

    do_simulate(x, map, rest)
  end

  defp move_robot(x, dir, map) do
    case can_move?(move(x, dir), dir, map, []) do
      {true, xs} ->
        map = move_elements([{x, map[x]} | xs], dir, map)
        {map, move(x, dir)}

      {false, _} ->
        {map, x}
    end
  end

  defp can_move?(x, dir, map, xs) do
    case map[x] do
      "O" ->
        {can_move?, xs} = can_move?(move(x, dir), dir, map, xs)
        {can_move?, [{x, map[x]} | xs]}

      "[" when dir in [@left, @right] ->
        {can_move?, xs} = can_move?(move(x, dir), dir, map, xs)
        {can_move?, [{x, map[x]} | xs]}

      "]" when dir in [@left, @right] ->
        {can_move?, xs} = can_move?(move(x, dir), dir, map, xs)
        {can_move?, [{x, map[x]} | xs]}

      "[" when dir in [@up, @down] ->
        {can_move_left?, xs_left} = can_move?(move(x, dir), dir, map, xs)
        {can_move_right?, xs_right} = can_move?(move(move(x, @right), dir), dir, map, xs)

        if can_move_left? and can_move_right? do
          {true, [{x, map[x]}, {move(x, @right), map[move(x, @right)]} | xs_left ++ xs_right]}
        else
          {false, xs}
        end

      "]" when dir in [@up, @down] ->
        {can_move_right?, xs_right} = can_move?(move(x, dir), dir, map, xs)
        {can_move_left?, xs_left} = can_move?(move(move(x, @left), dir), dir, map, xs)

        if can_move_left? and can_move_right? do
          {true, [{x, map[x]}, {move(x, @left), map[move(x, @left)]} | xs_left ++ xs_right]}
        else
          {false, xs}
        end

      "#" ->
        {false, xs}

      "." ->
        {true, xs}
    end
  end

  defp move_elements(xs, dir, map) do
    map = Enum.reduce(xs, map, fn {x, _}, acc -> Map.put(acc, x, ".") end)

    Enum.reduce(xs, map, fn {x, c}, acc ->
      acc
      |> Map.put(move(x, dir), c)
    end)
  end

  defp move({x, y}, {vx, vy}), do: {x + vx, y + vy}

  defp parse_input() do
    "assets/input15.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> then(fn [map, instructions] ->
      {get_area(map), instructions}
    end)
  end

  defp parse_input_part_two() do
    "assets/input15.txt"
    |> File.read!()
    |> String.replace("#", "##")
    |> String.replace("O", "[]")
    |> String.replace(".", "..")
    |> String.replace("@", "@.")
    |> String.split("\n\n", trim: true)
    |> then(fn [map, instructions] ->
      {get_area(map), instructions}
    end)
  end

  defp get_area(map) do
    map
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> transform_to_map()
  end

  defp transform_to_map(area) do
    m = length(area)
    n = length(hd(area))

    for i <- 0..(m - 1), j <- 0..(n - 1), reduce: %{} do
      result ->
        Map.put(
          result,
          {i, j},
          area
          |> Enum.at(i)
          |> Enum.at(j)
        )
    end
  end
end
