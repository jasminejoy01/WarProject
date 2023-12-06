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
        else:
            array2.append(element)
    return array1, array2

def replace_value(lst, old_value, new_value):
    return [new_value if x == old_value else x for x in lst]

def pull_cards(set1, set2, new_array):
    #print(replace_value(set1, 14, 1), replace_value(set2, 14, 2))
    #print(len(set1), len(set2), len(set1) + len(set2))
    
    if set1 != [] and set2 != []:
        print(set1[0], set2[0])
    print("---------")
    
    if len(set1) == 0 or len(set2) == 0:
        if set1 == []:
            set2 = replace_value(set2, 14, 1)
            #print(set2, len(set2))
            return set2
        else:
            set1 = replace_value(set1, 14, 1)
            #print(set1, len(set1))
            return set1
        
    elif len(set1) > 3 and len(set2) > 3:
        card_up_1 = set1[0]
        card_up_2 = set2[0]
        new_array = new_array + sorted([card_up_1, card_up_2], reverse = True)
        
        if card_up_1 < card_up_2:
            set1 = set1[1:]
            set2 = set2[1:] + new_array
            pull_cards(set1, set2, [])
            
        elif card_up_1 > card_up_2:
            set1 = set1[1:] + new_array
            set2 = set2[1:] 
            pull_cards(set1, set2, [])
            
        else:
            set1 = set1[2:]
            set2 = set2[2:]
            new_array = new_array + sorted(new_array, reverse = True)
            pull_cards(set1, set2, new_array)
    else:
        print("here now")
        card_up_1 = set1[0]
        card_up_2 = set2[0]
        new_array = new_array + [card_up_2, card_up_1]
        
        if card_up_1 < card_up_2:
            set1 = set1[1:]
            set2 = set2[1:] + sorted(new_array, reverse = True)
            pull_cards(set1, set2, [])
            
        elif card_up_1 > card_up_2:
            set1 = set1[1:] + sorted(new_array, reverse = True)
            set2 = set2[1:] 
            pull_cards(set1, set2, [])
            
        else:
            #print(set1, set2)
            new_array = new_array + [set1[1], set2[1]]
            new_array = sorted(new_array, reverse = True)
            set1 = set1[2:]
            set2 = set2[2:]
            #print("###")
            pull_cards(set1, set2, new_array)
 
### ----------------------------------------------------------------------------------------
### INITIALIZE
### ----------------------------------------------------------------------------------------
sets = (split_alternatively(replace_value(t20, 1, 14)))
pull_cards(sets[0], sets[1], [])
