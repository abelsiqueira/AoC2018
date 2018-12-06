using LinearAlgebra

include("../aux.jl")

function aocinput(file)
  lines = readlines(file)
  data = [Meta.parse.(v) for v in split.(lines, ", ")]
  sort!(data, lt=(x,y)->(x[1] < y[1]) || (x[1] == y[1] && x[2] < y[2]))
  return data
end

function tasks(data, max_distance)
  xmin, xmax = extrema([v[1] for v in data])
  ymin, ymax = extrema([v[2] for v in data])
  M = zeros(Int, 3 * (xmax - xmin), 3 * (ymax - ymin))
  Q = fill(false, 3 * (xmax - xmin), 3 * (ymax - ymin))
  data = [v + [xmax-xmin, ymax-ymin] for v in data]
  m, n = size(M)
  for i = 1:m, j = 1:n
    d = [norm([i;j] - v, 1) for v in data]
    Q[i,j] = sum(d) < max_distance
    mind = minimum(d)
    if count(d .== mind) == 1
      M[i,j] = argmin(d)
    end
  end

  D = [count(M .== k) for k = 1:length(data)]
  for i = 1:m
    for j = (M[i,1],M[i,n])
      j != 0 && (D[j] = 0)
    end
  end
  for j = 1:n
    for i = (M[1,j],M[m,j])
      i != 0 && (D[i] = 0)
    end
  end
  for k = 1:length(data)
    println("$k $(D[k])")
  end
  println("Max non null = $(findmax(D))")

  println("Safe size = $(count(Q .== true))")
end

function main()
  data = aocinput("ex.txt")
  tasks(data, 32)

  data = aocinput("input.txt")
  tasks(data, 10000)
end

main()
