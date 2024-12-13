defmodule Day11 do
  require Integer

  @input "872027 227 18 9760 0 4 67716 9245696"
  @depth 76

  def process() do
    @input
    |> String.split()
    |> create_tree()
    |> count()
  end

  defp create_tree(stones) do
    tree = %{-1 => stones}
    do_create_tree(stones, tree, @depth)
  end

  defp do_create_tree(_queue, tree, 1), do: tree
  defp do_create_tree([], tree, _depth), do: tree

  defp do_create_tree(queue, tree, depth) do
    {new_queue, tree} =
      for n <- queue, reduce: {[], tree} do
        {new_queue, tree} ->
          if Map.has_key?(tree, n) do
            {new_queue, tree}
          else
            children = evolve(n)
            {new_queue ++ children, Map.put(tree, n, children)}
          end
      end

    do_create_tree(new_queue, tree, depth - 1)
  end

  defp count(tree) do
    memo = %{}
    {count, _memo} = do_count(-1, tree, memo, @depth)

    count
  end

  defp do_count(n, _, memo, 0), do: {1, Map.put(memo, {n, 0}, 1)}

  defp do_count(n, tree, memo, depth) do
    if Map.has_key?(memo, {n, depth}) do
      {Map.get(memo, {n, depth}), memo}
    else
      {count, memo} =
        for child <- tree[n], reduce: {0, memo} do
          {count, memo} ->
            {sub_count, memo} = do_count(child, tree, memo, depth - 1)
            {count + sub_count, memo}
        end

      memo = Map.put(memo, {n, depth}, count)
      {count, memo}
    end
  end

  defp evolve(stone) do
    m = String.length(stone)

    case {stone, m} do
      {"0", _} ->
        ["1"]

      {stone, m} when Integer.is_even(m) ->
        {left, right} =
          String.split_at(stone, div(m, 2))

        left = left |> String.to_integer() |> Integer.to_string()
        right = right |> String.to_integer() |> Integer.to_string()

        [left, right]

      {stone, _} ->
        [stone |> String.to_integer() |> Kernel.*(2024) |> Integer.to_string()]
    end
  end
end
