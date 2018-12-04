include("../aux.jl")

function convert_claim(claim)
  m = match(r"#([0-9]+) @ ([0-9]+),([0-9]+): ([0-9]+)x([0-9]+)", claim)
  return Meta.parse.(m.captures)
end

function tasks(list)
  list = convert_claim.(list)
  M = zeros(Int, 1000, 1000)
  n = length(list)
  overlap = fill(false, n)
  for k = 1:n
    id, i, j, w, h = list[k]
    i, j = i+1, j+1
    I = CartesianIndices((i:i+w-1,j:j+h-1))
    if all(M[I] .== 0)
      M[I] .= id
    else
      overlap[k] = true
      for u in unique(M[I])
        u ≤ 0 && continue
        overlap[u] = true
      end
      K = findall(M[I] .!= 0)
      M[I[K]] .= -1
      K = findall(M[I] .== 0)
      M[I[K]] .= id
    end
  end
  c = count(M .== -1)
  println("c = $c")
  ov = findall(overlap .== false)
  println("ov = $ov")
end

function main()
  tasks(["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"])
  input = readlines("input.txt")
  tasks(input)
end

main()
