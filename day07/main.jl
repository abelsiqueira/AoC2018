using LightGraphs

function find_root(G)
  n = nv(G)
  root = fill(true, n)
  for i = 1:n
    I = neighbors(G, i)
    root[I] .= false
  end
  @assert count(root) == 1
  return findfirst(root)
end

function convert_to_pair(line)
  m = match(r"Step (.).*step (.)", line)
  v = m.captures
  return v[1] => v[2]
end

function prepate_graph(lines)
  pairs = convert_to_pair.(lines)
  nodes = sort(unique(union([v[1] for v in pairs], v[2] for v in pairs)))
  n = length(nodes)
  lookup = Dict(nodes[i] => i for i = 1:n)

  m = length(pairs)
  G = SimpleDiGraph(n)
  for i = 1:m
    p = pairs[i]
    from, to = lookup[p[1]], lookup[p[2]]
    add_edge!(G, from, to)
  end

  return nodes, G
end

function task01(lines)
  nodes, G = prepate_graph(lines)
  n = length(nodes)

  prereq = zeros(Int, n)
  for i = 1:n
    I = neighbors(G, i)
    prereq[I] .+= 1
  end
  done = fill(false, n)
  output = ""
  count = 0
  while !all(done)
    i = findfirst((prereq .== 0) .& (done .== false))
    output *= nodes[i]
    done[i] = true
    I = neighbors(G, i)
    prereq[I] .-= 1
    count += 1
    if count > n
      error("FU")
    end
  end
  println("output = $output")
end

function task02(lines, workers, extra)
  nodes, G = prepate_graph(lines)
  n = length(nodes)

  prereq = zeros(Int, n)
  for i = 1:n
    I = neighbors(G, i)
    prereq[I] .+= 1
  end
  #println("prereq = $prereq")
  done = fill(false, n)
  output = ""
  Wtime = zeros(Int, workers)
  Wjob  = zeros(Int, workers)
  time_passed = 0
  while !(all(done) && all(Wjob .== 0))
    i = findfirst((prereq .== 0) .& (done .== false))
    j = findfirst(Wtime .== 0)
    if i != nothing && j != nothing # There is something ready and worker available
      #println("i = $i, j = $j")
      done[i] = true # Though not done, it is getting done
      Wtime[j] = extra + i # Assumption: All letters are present.
      Wjob[j] = i
    else # Nothing ready or no worker available, wait for some worker to finish
      S = findall(Wtime .> 0)
      #println("S = $S")
      @assert length(S) > 0
      t = minimum(Wtime[S])
      #println("t = $t")
      Wtime[S] .-= t # Time passes
      time_passed += t
      I = [i for i = S if Wtime[i] == 0] # Which of these is complete
      for k = I
        #println("Sk = $(k)")
        N = neighbors(G, Wjob[k])
        #println("N = $N, neighbors of $(nodes[S[k]])")
        prereq[N] .-= 1
      end
      output *= join(nodes[Wjob[I]])
      Wjob[I] .= 0
    end
    #println("output = $output")
    #println("time_passed = $time_passed")
    #println("prereq = $prereq")
    #println("Wtime = $Wtime")
    #println("Wjob = $([w == 0 ? " " : nodes[w] for w in Wjob])")
  end
  println("output = $output")
  println("time = $time_passed")
end

function main()
  input = readlines("ex.txt")
  task01(input)
  task02(input, 2, 0)

  input = readlines("input.txt")
  task01(input)
  task02(input, 5, 60)
end

main()
