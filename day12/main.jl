using Printf

function process_input(lines)
  initial = split(lines[1], ": ")[2]
  n = length(initial)
  initial = Dict(i - 1 => initial[i:i] for i = 1:n if initial[i:i] == "#")
  rules = Dict()
  for line in lines[3:end]
    a, b = split(line, " => ")
    rules[a] = b
  end
  return initial, rules
end

function join_state(state)
  r1, r2 = extrema(keys(state))
  f(i) = haskey(state, i) ? state[i] : "."
  join([f(i) for i in r1:r2])
end

function get_local_state(state, j)
  f(i) = haskey(state, i) ? state[i] : "."
  return join([f(i) for i = j-2:j+2])
end

function print_state(state)
  j = minimum(state)[1]
  @printf("Start %3d: ", j)
  println(join_state(state))
end

function task01(state, rules, epochs = 20)
  print_state(state)
  prev_states = [state]
  prev_join_states = [join_state(state)]
  for i = 1:epochs
    new_state = Dict()
    λ, Λ = minimum(state)[1], maximum(state)[1]
    for j = λ - 2:Λ + 2
      neighbors = get_local_state(state, j)
      if (haskey(rules, neighbors) ? rules[neighbors] : ".") == "#"
        new_state[j] = "#"
      end
    end

    while minimum(new_state)[2] == "."
      delete!(new_state, minimum(new_state)[1])
    end
    while maximum(new_state)[2] == "."
      delete!(new_state, maximum(new_state)[1])
    end
    if join_state(state) == join_state(new_state)
      println("Repetition found")
      δ = minimum(new_state)[1] - minimum(state)[1]
      n = epochs - i + 1
      state = Dict(n*δ + k => v for (k,v) in state)
      break
    end
    state = new_state
    print_state(state)
    push!(prev_states, state)
    push!(prev_join_states, join_state(state))
  end
  sol = sum(k for (k,v) in state if v == "#")
  println("sol = $sol")
end

function main()
  initial, rules = process_input(readlines("ex.txt"))
  task01(initial, rules)

  initial, rules = process_input(readlines("input.txt"))
  task01(initial, rules)
  task01(initial, rules, 50000000000)
end

main()
