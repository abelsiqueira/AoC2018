function part01(input)
  println("s = $(sum(input))")
end

function part02(input)
  seq = Int[]
  i = 1
  n = length(input)
  s = 0
  # Se repete na primeira sequência
  for i = 1:n
    s = s + input[i]
    if s in seq
      println("Solução: $s")
      return
    end
    push!(seq, s)
  end

  # Senão, cria um shift na sequência toda
  while true
    δ = s + input[1] - seq[1]
    newseq = seq .+ δ
    indin = indexin(newseq, seq)
    j = findfirst(indin .!= nothing)
    if j != nothing
      j = indin[j]
      println("Solução = $(seq[j])")
      println("|seq| = $(length(seq))")
      return
    end
    append!(seq, newseq)
    s += δ
  end
end

function main()
  println("Novo problema")
  test = [1, -1]
  part01(test)
  part02(test)
  println()
  println("Novo problema")
  test = [3, 3, 4, -2, -4]
  part01(test)
  part02(test)
  println()
  println("Novo problema")
  test = [-6, 3, 8, 5, -6]
  part01(test)
  part02(test)
  println()
  println("Novo problema")
  test = [7, 7, -2, -7, -4]
  part01(test)
  part02(test)
  println()
  println("Problema real")
  lines = eval.(Meta.parse.(readlines("input.txt")))
  part01(lines)
  part02(lines)
end

main()
