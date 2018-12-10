function calcbox(P)
  return [extrema(P[:,1])...; extrema(P[:,2])...]
end

function matrix_position(P)
  n = size(P, 1)
  box = calcbox(P)
  ny, nx = box[2]-box[1]+1, box[4]-box[3]+1
  M = fill(".", ny, nx)
  for i = 1:n
    y, x = P[i,:]
    M[y-box[1]+1, x-box[3]+1] = "#"
  end
  return M
end

function print_position(P)
  # M = matrix_position(P) OutOfMemory
  n = size(P, 1)
  box = calcbox(P)
  ny, nx = box[2]-box[1]+1, box[4]-box[3]+1
  for i = 1:nx
    for j = 1:ny
      if any(P[k,:] - [box[1]-1; box[3]-1] == [j;i] for k = 1:n)
        print("#")
      else
        print(".")
      end
    end
    println("")
  end
  println("")
end

function move(P, V)
  P .+= V
end

function task01(P, V)
  min_box_area = Inf
  t = 0
  while true
    box = calcbox(P)
    box_area = (box[2] - box[1] + 1) * (box[4] - box[3] + 1)
    if box_area < min_box_area
      min_box_area = box_area
    else
      t -= 1
      P .-= V
      println("After $t seconds")
      print_position(P)
      break
    end
    P .+= V
    t += 1
  end
end

function process_input(lines)
  n = length(lines)
  P = zeros(Int, n, 2)
  V = zeros(Int, n, 2)
  for (i,line) in enumerate(lines)
    m = match(r"<(.*)>.*<(.*)>", line)
    P[i,:] = Meta.parse.(split(m[1], ","))
    V[i,:] = Meta.parse.(split(m[2], ","))
  end
  return P, V
end

function main()
  P, V = process_input(readlines("ex.txt"))
  task01(P, V)

  P, V = process_input(readlines("input.txt"))
  task01(P, V)
end

main()
