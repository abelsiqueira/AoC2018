function value(x, y, gsn)
  rackid = 10 + x
  pwr = rackid * y
  pwr += gsn
  pwr = pwr * rackid
  pwr = div(pwr, 100) % 10 - 5
  return pwr
end

function task01(gsn)
  M = [value(x, y, gsn) for y = 1:300, x = 1:300]
  [sum(M[i:i+2,j:j+2]) for i = 1:298, j = 1:298] |> findmax |> println
end

function task02(gsn)
  M = [value(x, y, gsn) for y = 1:300, x = 1:300]
  best = (0, (0,0))
  bestk = 0
  for k = 1:299
    localbest = findmax([sum(M[i:i+k,j:j+k]) for i = 1:300-k, j = 1:300-k])
    if localbest[1] < 0
      break
    end
    if localbest[1] > best[1]
      best = localbest
      bestk = k
    end
  end
  println("best = $best, bestk = $bestk")
end

function main()
  @assert value(3, 5, 8) == 4
  @assert value(122,  79, 57) == -5
  @assert value(217, 196, 39) == 0
  @assert value(101, 153, 71) == 4
  task01(18)
  task01(42)
  task01(7857)
  task02(18)
  task02(42)
  task02(7857)
end

main()
