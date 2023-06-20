def selection_sort(nums):
    n = len(nums)

    for i in range(n-1):
        min_idx = i

        for j in range(i+1, n):
            if nums[j] < nums[min_idx]:
                min_idx = j

        nums[i], nums[min_idx] = nums[min_idx], nums[i]

    return nums

nums = [5,7,9,1,3,45,77,11,5,4,7]
print(selection_sort(nums))
