defmodule Day17 do
  import Bitwise

  @last_op 15
  @input String.split("2,4,1,1,7,5,0,3,1,4,4,0,5,5,3,0", ",") |> Enum.map(&String.to_integer/1)

  def process_part_one() do
    initial_state = %{a: 32_916_674, b: 0, c: 0, ptr: 0, out: []}

    @input
    |> Enum.with_index()
    |> Map.new(fn {instruction, idx} -> {idx, instruction} end)
    |> process(initial_state)
  end

  def process_part_two() do
    initial_state = %{a: 0, b: 0, c: 0, ptr: 11, out: @input}

    @input
    |> Enum.with_index()
    |> Map.new(fn {instruction, idx} -> {idx, instruction} end)
    |> process_reverse(initial_state)
  end

  defp process_reverse(_, %{a: a, ptr: 0, out: []}), do: a

  defp process_reverse(instructions, state) do
    operator = get_operator_reverse(instructions[state.ptr])
    operand = instructions[state.ptr + 1]

    process_reverse(instructions, operator.(operand, state))
  end

  def process_part_two_bruteforce() do
    initial_state = %{b: 0, c: 0, ptr: 0, out: []}

    @input
    |> Enum.with_index()
    |> Map.new(fn {instruction, idx} -> {idx, instruction} end)
    |> find_a_brutforce(initial_state)
  end

  defp process(_, %{ptr: ptr, out: out}) when ptr > @last_op - 1, do: out

  defp process(instructions, state) do
    operator = get_operator(instructions[state.ptr])
    operand = instructions[state.ptr + 1]

    process(instructions, operator.(operand, state))
  end

  defp process_checking(_, %{ptr: ptr}) when ptr > @last_op - 1, do: false

  defp process_checking(instructions, state) do
    case analyze(state.out) do
      :same ->
        true

      :invalid ->
        false

      :valid ->
        operator = get_operator(instructions[state.ptr])
        operand = instructions[state.ptr + 1]

        process_checking(instructions, operator.(operand, state))
    end
  end

  def analyze(out) do
    do_analyze(out, @input)
  end

  defp do_analyze([], []), do: :same
  defp do_analyze([], _), do: :valid
  defp do_analyze(_, []), do: :invalid
  defp do_analyze([a | as], [a | bs]), do: do_analyze(as, bs)
  defp do_analyze(_, _), do: :invalid

  defp find_a_brutforce(instructions, state) do
    0
    |> Stream.iterate(fn x -> x + 1 end)
    |> Enum.find(&process_checking(instructions, Map.put(state, :a, &1)))
  end

  defp combo(operand, state) do
    case operand do
      n when n in 0..3 -> n
      4 -> state.a
      5 -> state.b
      6 -> state.c
      _ -> raise "Invalid operand"
    end
  end

  defp adv(operand, state) do
    result = div(state.a, Integer.pow(2, combo(operand, state)))
    %{state | a: result, ptr: state.ptr + 2}
  end

  defp advr(operand, state) do
    result = state.a * Integer.pow(2, combo(operand, state))
    %{state | a: result, ptr: state.ptr - 2}
  end

  defp bxl(operand, state) do
    result = bxor(state.b, operand)
    %{state | b: result, ptr: state.ptr + 2}
  end

  defp bxlr(operand, state) do
    result = bxor(state.b, operand)
    %{state | b: result, ptr: state.ptr - 2}
  end

  defp bst(operand, state) do
    result = Integer.mod(combo(operand, state), 8)
    %{state | b: result, ptr: state.ptr + 2}
  end

  defp bstr(operand, state) do
    result = Integer.mod(combo(operand, state), 8)
    %{state | b: result, ptr: state.ptr + 2}
  end

  defp jnz(operand, state) do
    case state.a do
      0 -> %{state | ptr: state.ptr + 2}
      _ -> %{state | ptr: operand}
    end
  end

  defp bxc(_operand, state) do
    result = bxor(state.b, state.c)
    %{state | b: result, ptr: state.ptr + 2}
  end

  defp out(operand, state) do
    result = Integer.mod(combo(operand, state), 8)
    %{state | out: state.out ++ [result], ptr: state.ptr + 2}
  end

  defp bdv(operand, state) do
    result = div(state.a, Integer.pow(2, combo(operand, state)))
    %{state | b: result, ptr: state.ptr + 2}
  end

  defp cdv(operand, state) do
    result = div(state.a, Integer.pow(2, combo(operand, state)))
    %{state | c: result, ptr: state.ptr + 2}
  end

  defp get_operator(instruction) do
    case instruction do
      0 -> &adv/2
      1 -> &bxl/2
      2 -> &bst/2
      3 -> &jnz/2
      4 -> &bxc/2
      5 -> &out/2
      6 -> &bdv/2
      7 -> &cdv/2
    end
  end

  defp get_reverse(instruction) do
    case instruction do
      0 -> &adv/2
      1 -> &bxl/2
      2 -> &bst/2
      3 -> &jnz/2
      4 -> &bxc/2
      5 -> &out/2
      6 -> &bdv/2
      7 -> &cdv/2
    end
  end
end
