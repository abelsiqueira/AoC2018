using Unicode

function react(p1, p2)
  return !(islowercase(p1) && islowercase(p2)) &&
         !(isuppercase(p1) && isuppercase(p2)) &&
          (uppercase(p1) == uppercase(p2))
end

function reaction(str)
  done = false
  while !done
    done = true
    n = length(str)
    for i = 1:n-1
      if react(str[i], str[i+1])
        done = false
        str = str[1:i-1] * str[i+2:end]
        break
      end
    end
  end
  return str
end

function task01(str)
  str = reaction(str)
  if length(str) < 50
    println("str = $str")
  end
  println("|str| = $(length(str))")
end

function task02(str)
  U = join(unique(str))
  U = join(unique(lowercase.(U)))
  m = length(U)
  smallest = (length(str), str, "")
  for j = 1:m
    strR = replace(replace(str, U[j:j] => ""), uppercase(U)[j:j] => "")
    strout = reaction(strR)
    if length(strout) < smallest[1]
      smallest = (length(strout), strR, U[j])
    end
  end
  println("Smallest = $((smallest[1],smallest[3]))")
end

function main()
  task01("aA")
  task01("abBA")
  task01("abAB")
  task01("aabAAB")
  task01("dabAcCaCBAcCcaDA")
  input = readline("input.txt")
  task01(input)

  task02("dabAcCaCBAcCcaDA")
  task02(input)
end

main()
