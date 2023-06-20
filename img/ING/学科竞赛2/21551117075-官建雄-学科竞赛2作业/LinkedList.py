#创建节点类
class Node:
    def __init__(self, value):
        self.value = value
        self.next = None

#创建链表类
class LinkedList:
    def __init__(self):
        self.head = None

    def append(self, value):    #添加节点方法
        new_node = Node(value)
        if self.head is None:
            self.head = new_node
        else:
            current = self.head
            while current.next:
                current = current.next
            current.next = new_node

    def delete(self, value):    #删除节点方法
        if self.head is None:
            return

        if self.head.value == value:
            self.head = self.head.next
            return

        current = self.head
        while current.next:
            if current.next.value == value:
                current.next = current.next.next
                return
            current = current.next

    def print_list(self):    #打印列表方法
        if self.head is None:
            print("LinkedList is empty")
        else:
            current = self.head
            while current:
                print(current.value, end=" ")
                current = current.next
            print()


# 创建LinkedList实例
linked_list = LinkedList()

# 在链表末尾添加节点值为 1
linked_list.append(1)

# 在链表末尾添加节点值为 2
linked_list.append(2)

# 在链表末尾添加节点值为 3
linked_list.append(3)

# 打印链表中所有节点的值
linked_list.print_list()

# 删除节点值为 2 的节点
linked_list.delete(2)

# 打印链表中所有节点的值
linked_list.print_list()
