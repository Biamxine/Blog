def dfs(graph, start_node):
    visited = set()
    result = []

    def dfs_recursive(node):
        visited.add(node)
        result.append(node)

        for neighbor in graph[node]:
            if neighbor not in visited:
                dfs_recursive(neighbor)

    dfs_recursive(start_node)
    return result

graph = {
    'A': ['B', 'C'],
    'B': ['D', 'E'],
    'C': ['G'],
    'D': [],
    'E': ['F'],
    'F': [],
    'G': ['A']
}

start_node = 'A'

traversal_result = dfs(graph, start_node)
print("DFS遍历结果:", traversal_result)

