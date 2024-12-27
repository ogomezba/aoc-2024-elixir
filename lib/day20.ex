defmodule Day20 do
  @up {-1, 0}
  @down {1, 0}
  @left {0, -1}
  @right {0, 1}

  def process_part_one() do
    input = File.read!("assets/input20.txt")

    area = get_area(input)
    {start, _} = Enum.find(area, fn {_, v} -> v == "S" end)

    candidate_cheats =
      area
      |> Map.keys()
      |> Enum.filter(&(area[&1] == "#"))
      |> Enum.flat_map(fn coords ->
        cheats = []

        cheats =
          if look(area, coords, @up) != "#" and look(area, coords, @down) != "#" do
            [
              {move(coords, @up), move(coords, @down)},
              {move(coords, @down), move(coords, @up)} | cheats
            ]
          else
            cheats
          end

        if look(area, coords, @left) != "#" and look(area, coords, @right) != "#" do
          [
            {move(coords, @left), move(coords, @right)},
            {move(coords, @right), move(coords, @left)} | cheats
          ]
        else
          cheats
        end
      end)

    base_steps = bfs(area, [start], MapSet.new(), 0, {nil, nil})

    for candidate_cheat <- candidate_cheats do
      case bfs(area, [start], MapSet.new(), 0, candidate_cheat) do
        :infinity -> :infinity
        steps -> base_steps - (steps + 1)
      end
    end
    |> Enum.count(fn val -> val != :infinity and val >= 100 end)
  end

  defp bfs(area, queue, visited, steps, {cheat_start, cheat_end} = cheat) do
    result =
      Enum.reduce_while(queue, {false, visited, []}, fn coords, {_, visited, next_queue} ->
        if MapSet.member?(visited, coords) do
          {:cont, {false, visited, next_queue}}
        else
          visited = MapSet.put(visited, coords)

          case area[coords] do
            "E" ->
              {:halt, {true, visited, []}}

            _ when coords == cheat_start ->
              {:halt, {false, visited, [cheat_end]}}

            c when c in ["#", nil] ->
              {:cont, {false, visited, next_queue}}

            _ ->
              visited = MapSet.put(visited, coords)

              next =
                for dir <- [@up, @right, @down, @left],
                    coords = move(coords, dir),
                    coords not in next_queue do
                  coords
                end

              {:cont, {false, visited, next ++ next_queue}}
          end
        end
      end)

    case result do
      {false, _visited, []} ->
        :infinity

      {true, _visited, _new_queue} ->
        steps

      {false, visited, new_queue} ->
        bfs(area, new_queue, visited, steps + 1, cheat)
    end
  end

  defp get_area(map) do
    map
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> transform_to_map()
  end

  defp move({i, j}, {di, dj}) do
    {i + di, j + dj}
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

  defp look(area, coords, v) do
    area[move(coords, v)]
  end
end
