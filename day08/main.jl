mutable struct Node
  childs :: Array{Node}
  content :: Array{Int}
  Node() = new([], [])
end

function print_tree(node, depth=0)
  println("-" ^ depth * "$(node.content)")
  for c in node.childs
    print_tree(c, depth+1)
  end
end

function sum_tree_content(node)
  s = length(node.content) == 0 ? 0 : sum(node.content)
  for c in node.childs
    s += sum_tree_content(c)
  end
  return s
end

function value(node)
  length(node.childs) == 0 && return sum(node.content)
  s = 0
  for i = node.content
    if 1 ≤ i ≤ length(node.childs)
      s += value(node.childs[i])
    end
  end
  return s
end

function add_node(line)
  childs = line[1]
  len_contents = line[2]
  node = Node()
  k = 3
  for c = 1:childs
    child, i = add_node(line[k:end])
    # TODO: i
    push!(node.childs, child)
    k += i - 1
  end
  append!(node.content, line[k:k+len_contents-1])
  k += len_contents
  return node, k
end

function tasks(line)
  line = Meta.parse.(split(line))

  tree, len = add_node(line)
  #print_tree(tree)
  s = sum_tree_content(tree)
  println("sum = $s")
  s = value(tree)
  println("value = $s")
end

function main()
  input = readline("ex.txt")
  tasks(input)

  input = readline("input.txt")
  tasks(input)
end

main()
