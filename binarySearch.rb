class Node
    attr_accessor :data, :left, :right
    
    def initialize(data = nil, left = nil, right = nil)
        @data = data
        @left = left
        @right = right
    end
end

class Tree
    attr_accessor :root

    def initialize(array)
        array = sortArr(array)
        @root = buildTree(array)
    end

    def buildTree(array)
        return nil if array.empty?
        middle = (array.length / 2).floor

        nextRoot = Node.new(array[middle])
        nextRoot.left = buildTree(array[0...middle])
        nextRoot.right = buildTree(array[middle + 1...])

        return nextRoot
    end

    def sortArr(array)
        return array.uniq.sort
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end

    def find(value, root = @root)
        return nil if root.nil?
        return root if root.data == value

        return root.data < value ? find(value, root.right) : find(value, root.left)
    end

    def insert(value, root = @root)
        return @root = Node.new(value) if @root.nil?
        return Node.new(value) if root.nil?
        
        root.data < value ? root.right = insert(value, root.right) : root.left = insert(value, root.left)
        return root
    end

    def delete(root = @root, value)
        return root if root.nil?

        if(value < root.data)
            root.left = delete(root.left, value)
        elsif(value > root.data)
            root.right = delete(root.right, value)
        else
            if(root.left.nil?)
                temp = root.right
                root = nil
                return temp
            elsif(root.right.nil?)
                temp = root.left
                root = nil
                return root
            end

            temp = minValueNode(root.right)
            root.data = temp.value
            root.right = delete(root.right, temp.value)
        end
        return root
    end

    def levelOrder(root = @root, queue = [])
        return root if root.nil?

        array = []
        queue.append(root)

        while(queue.length.positive?)
            array.append(queue[0].data)
            root = queue.shift

            queue << root.left unless root.left.nil?
            queue << root.right unless root.right.nil?
        end
        return array
    end

    def minValueNode(root = @root)
        current = root

        until(current.left.nil?)
            current = current.left
        end

        return current.data
    end

    def preOrder(root = @root, array = [])
        return root if root.nil?

        if(!root.nil?)
            array << root.data
            preOrder(root.left, array)
            preOrder(root.right, array)
        end
        return array
    end

    def inOrder(root = @root, array = [])
        return root if root.nil?

        if(!root.nil?)
            inOrder(root.left, array)
            array << root.data
            inOrder(root.right, array)
        end
        return array
    end

    def postOrder(root = @root, array = [])
        return root if root.nil?

        if(!root.nil?)
            postOrder(root.left, array)
            postOrder(root.right, array)
            array << root.data

        end
        return array
    end

    def height(root = @root)
        return 0 if root.nil?

        lDepth = height(root.left)
        rDepth = height(root.right)

        lDepth > rDepth ? lDepth + 1 : rDepth + 1
    end

    def balanced?(root = @root)
        return true if root.nil?

        lHeight = height(root.left)
        rHeight = height(root.right)

        if ((lHeight.abs - rHeight.abs <= 1) && balanced?(root.left) == true && balanced?(root.right) == true)
            return true
        else
            return false
        end
    end

    def rebalance(root = @root)
        @root = buildTree(levelOrder)
    end
end

array = Array.new(15) { rand(1..100) }
bs = Tree.new(array)

puts "Is Tree Balanced: #{bs.balanced?}"; puts

puts "Level Order: #{bs.levelOrder}"
puts "Pre Order: #{bs.preOrder}"
puts "In Order: #{bs.inOrder}"
puts "Post Order: #{bs.postOrder}"; puts

puts "Inserting Numbers between 100 and 1000"
100.times do
    bs.insert(rand(100..1000))
end
puts "Is Tree Still Balanced: #{bs.balanced?}"; puts

puts "Rebalancing Tree"
bs.rebalance
puts "Is Tree Balanced: #{bs.balanced?}"; puts

puts "Level Order: #{bs.levelOrder}"
puts "Pre Order: #{bs.preOrder}"
puts "In Order: #{bs.inOrder}"
puts "Post Order: #{bs.postOrder}"; puts

puts "Find 5: #{bs.find(5)}"
puts "Find 55: #{bs.find(55)}"; puts

puts "Minimum Value in the Tree: #{bs.minValueNode}"
puts "Maximum Depth is: #{bs.height}"; puts

puts "Visual Rep of Tree:"
puts bs.pretty_print






# https://www.geeksforgeeks.org/binary-search-tree-set-1-search-and-insertion/?ref=lbp
# https://www.geeksforgeeks.org/binary-search-tree-set-2-delete/?ref=lbp
# https://www.youtube.com/watch?v=wcIRPqTR3Kc&feature=youtu.be&ab_channel=colleenlewis
# https://www.youtube.com/watch?v=86g8jAQug04&ab_channel=mycodeschool
# https://www.geeksforgeeks.org/write-a-c-program-to-find-the-maximum-depth-or-height-of-a-tree/
# https://www.geeksforgeeks.org/how-to-determine-if-a-binary-tree-is-balanced/?ref=lbp