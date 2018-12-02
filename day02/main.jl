function check(x)
  s = split(x, "")
  u = unique(s)
  has2 = has3 = false
  for ui in u
    c = count(ui .== s)
    c == 2 && (has2 = true)
    c == 3 && (has3 = true)
  end
  return has2, has3
end

function task01(list)
  n2 = 0
  n3 = 0
  for x in list
    has2, has3 = check(x)
    has2 && (n2 += 1)
    has3 && (n3 += 1)
  end
  println("n2 = $n2, n3 = $n3")
  println("cksum = $(n2 * n3)")
end

function task02(list)
  n = length(list)
  k = length(list[1])
  for i = 1:n-1
    si = split(list[i], "")
    for j = i+1:n
      sj = split(list[j], "")
      cmp = si .== sj
      if count(cmp) == k - 1
        sub = join(si[findall(cmp)])
        println("sub = $sub")
      end
    end
  end
end

function main()
  task01(["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"])

  list = readlines("input.txt")
  task01(list)

  task02(["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"])
  task02(list)
end

main()
