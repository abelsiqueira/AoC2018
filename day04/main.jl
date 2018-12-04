function get_time(line)
  m = match(r"1518-(..)-(..) (..):(..)", line)
  return Meta.parse.(m.captures)
end

function get_guard(line)
  m = match(r"#([0-9]+) ", line)
  return Meta.parse(m[1])
end

function get_sleep(falls_asleep, wakes_up)
  @assert occursin("falls asleep", falls_asleep)
  @assert occursin("wakes up", wakes_up)
  fa = get_time(falls_asleep)
  wu = get_time(wakes_up)
  @assert fa[1] == wu[1] && fa[2] == wu[2] # Same day
  return fa[1], fa[2], fa[4]:wu[4]-1
end

function tasks(lines)
  I = findall(x -> occursin("Guard", x), lines)
  guards = unique([get_guard(x) for x in lines[I]])
  ng = length(guards)

  n = length(lines)
  push!(I, n)

  sleep_per_guard = Dict{Int,Array}(g => [] for g in guards)
  sum_sleep_per_guard = Dict{Int,Int}(g => 0 for g in guards)
  minutes_per_guard = Dict{Int,Array}(g => zeros(Int, 60) for g in guards)

  for i = 1:length(I)-1
    guard = get_guard(lines[I[i]])
    for j = I[i]+1:2:I[i+1]-1
      mon, day, sleep = get_sleep(lines[j], lines[j+1])
      #println("Guard #$guard on $day/$mon sleeps $sleep")
      push!(sleep_per_guard[guard], (mon,day,sleep))
      sum_sleep_per_guard[guard] += length(sleep)
      minutes_per_guard[guard][sleep .+ 1] .+= 1
    end
  end

  println("guards = $guards")
  guard = argmax(sum_sleep_per_guard)
  println("guard $guard sleeps the most")

  m = argmax(minutes_per_guard[guard]) - 1
  println("most sleep: $m")
  println("sol: $(guard * m)")

  most_slept_minute_per_guard = [findmax(minutes_per_guard[g]) for g in guards]
  println("msmpg = $most_slept_minute_per_guard")
  # findmax for iterables?
  minute, how_much, guard = -1, -1, -1
  for (i, msm) in enumerate(most_slept_minute_per_guard)
    if msm[1] > how_much
      minute, how_much, guard = msm[2]-1, msm[1], guards[i]
    end
  end
  println("minute with most sleep: $minute ($how_much minutes)")
  println("guard in that minute: $guard")
  println("sol: $(guard * minute)")
end

function main()
  input = readlines("ex.txt")
  tasks(sort(input))

  input = readlines("input.txt")
  tasks(sort(input))
end

main()
