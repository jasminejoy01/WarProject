# -*- coding: utf-8 -*-
"""
Created on Wed Dec  6 10:53:37 2023

@author: JoyJ
"""

t20 = [1,2,3,4,5,6,7,8,9,10,11,12,1,2,3,4,5,6,7,8,9,10,11,12,1,2,3,4,5,6,7,8,9,10,11,12,1,2,3,4,5,6,7,8,9,10,11,12,13,13,13,13]
r20 = [5,2,9,6,1,6,11,4,10,5,9,3,13,5,11,3,1,4,12,2,7,2,3,2,1,13,13,11,10,10,13,12,12,9,7,4,1,7,10,4,11,5,6,3,12,9,8,8,8,8,7,6]

### ----------------------------------------------------------------------------------------
### FUNCTIONS
### ----------------------------------------------------------------------------------------
def split_alternatively(arr):
    array1 = []
    array2 = []
    for i, element in enumerate(arr):
        if i % 2 == 0:
            array1.append(element)
            #array1 = array1[::-1]
        else:
            array2.append(element)
            #array2 = array2[::-1]
    return array1, array2

def replace_value(lst, old_value, new_value):
    return [new_value if x == old_value else x for x in lst]

def pull_cards(set1, set2, new_array):
    if len(set1) == 52 or len(set2) == 52:
        print(replace_value(set1, 14, 1))
        print(replace_value(set2, 14, 1))
        #print(len(set1), len(set2), len(set1) + len(set2))
        print("---------")
        if set1 == []:
            set2 = set2 + sorted(new_array, reverse =  True)
            return replace_value(set2, 14, 1)
        else:
            set1 = set1 + sorted(new_array, reverse =  True)
            return replace_value(set1, 14, 1)
        
    elif len(set1) > 3 and len(set2) > 3:
        index = 0
        if set1[index:index+1] < set2[index:index+1]:
            new_array = sorted(new_array + set1[index:index+1] + set2[index:index+1], reverse = True)
            pull_cards(set1[index+1:]              , set2[index+1:]+ new_array , [])
        elif set1[index:index+1] > set2[index:index+1]:
            new_array = sorted( new_array + set1[index:index+1] + set2[index:index+1], reverse = True)
            pull_cards(set1[index+1:] + new_array, set2[index+1:] , [])
        else:
            index = 2
            new_array = sorted(new_array + set1[:index] + set2[:index], reverse = True)
            print("arr", new_array)
            pull_cards(set1[index:], set2[index:], new_array)
            
    else:
        print("here now")
        index = 0
        
        if set1[index:index+1] < set2[index:index+1]:
            new_array = sorted(new_array + set1[index:index+1] + set2[index:index+1], reverse = True)
            pull_cards(set1[index+1:]            , set2[index+1:] + new_array, [])
        elif set1[index:index+1] > set2[index:index+1]:
            new_array = sorted( new_array + set1[index:index+1] + set2[index:index+1], reverse = True)
            pull_cards(set1[index+1:] + new_array, set2[index+1:], [])
        else:
            print(replace_value(set1, 14, 1))
            print(replace_value(set2, 14, 1))
            #print(len(set1), len(set2), len(set1) + len(set2))
            index = 2
            new_array = sorted(new_array + set1[:index] + set2[:index], reverse = True)
            print("array", new_array)
            pull_cards(set1[index:], set2[index:], new_array)

 
### ----------------------------------------------------------------------------------------
### INITIALIZE
### ----------------------------------------------------------------------------------------
t20 = t20[::-1]
sets = (split_alternatively(replace_value(t20, 1, 14)))
result = (pull_cards(sets[0], sets[1], []) == r20)

