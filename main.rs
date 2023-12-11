#![allow(non_snake_case,non_camel_case_types,dead_code)]

/*
    Below is the function stub for deal. Add as many helper functions
    as you like, but the deal function should not be modified. Just
    fill it in.

    Test your code by running 'cargo test' from the war_rs directory.
*/


/* split_alternatively, splits a Vec<u8> into two vectors alternatively, one for each player. 
*/
fn split_alternatively<u8>(input: Vec<u8>) -> (Vec<u8>, Vec<u8>) {
    let mut first = Vec::new();
    let mut second = Vec::new();

    for (index, item) in input.into_iter().enumerate() {
        if index % 2 == 0 {
            first.push(item);
        } else {
            second.push(item);
        }
    }
    (first, second)
}

/* replace_one and replace_fourteen are identically, difference being
replace_ones changes all the 1s to 14s (since Ace = 1 and Ace has the highest rank)
replace_fourteen changes all the 14s back to 1s (is the last step before returning output)
*/
fn replace_ones(input: Vec<u8>) -> Vec<u8> {
    let iter = input.into_iter();
    let modified_iter = iter.map(|x| if x == 1 { 14 } else { x });
    let modified_list: Vec<u8> = modified_iter.collect();
    modified_list
}

fn replace_fourteen(input: Vec<u8>) -> Vec<u8> {
    let iter = input.into_iter();
    let modified_iter = iter.map(|x| if x == 14 { 1 } else { x });
    let modified_list: Vec<u8> = modified_iter.collect();
    modified_list
}

/*
pull_cards is the main function that takes in three sets of Vec<u8> (both player's hands, 26 each, and an empty set that would hold the cards in case both players draw cards of the same rank) and returns the winning Vec<u8> (size 52)
The design of pull_cards is as follows:
CASE 1: both sets have more than 3 elements
CASE 2: at least one set had no elements
CASE 3: at least one set has <= 3 elements but >1
*/
fn pull_cards(set1: &mut Vec<u8>, set2: &mut Vec<u8>, new_array: &mut Vec<u8>) -> Vec<u8> {
    let mut finalset: Vec<u8> = Vec::new();
    //println!("set1 {:?}", set1);
    //println!("set2 {:?}", set2);
    //println!("new_array {:?}", new_array);
    if set1.len() > 3 && set2.len() > 3 {
        /* CASE 1: both sets have more than 3 elements 
            1a: player 2 draws card with higher rank
            1b: player 1 draws card with higher rank
            1c: both cards have same rank
        */
        let index = 0;
        if let (Some(&elem1), Some(&elem2)) = (set1.get(index), set2.get(index)) {
            if elem1 < elem2 {
                new_array.push(elem1);
                new_array.push(elem2);
                new_array.sort_by(|a, b| b.cmp(a));
                set2.append(new_array);
                set1.remove(index);
                set2.remove(index);
                return pull_cards(set1, set2, new_array);
            } else if elem1 > elem2 {
                new_array.push(elem1);
                new_array.push(elem2);
                new_array.sort_by(|a, b| b.cmp(a));
                set1.append(new_array);
                set1.remove(index);
                set2.remove(index);
                return pull_cards(set1, set2, new_array);
            } else {
                let index = 2;
                new_array.extend_from_slice(&set1[..index]);
                new_array.extend_from_slice(&set2[..index]);
                new_array.sort_by(|a, b| b.cmp(a));
                set1.drain(..index);
                set2.drain(..index);
                return pull_cards(set1, set2, new_array);
            }
        }
    } else if set1.len() == 0 || set2.len() == 0 {
        /* CASE 2: recursion exit scnario
          if set1 is empty, add all cards in new_array to set2 and return set2
          if set2 is empty, add all cards in new_array to set1 and return set1

          also, replace the 14s to 1s 
        */
        if set1.is_empty() {
            //println!("new_array {:?}", new_array);
            //new_array.sort_by(|a, b| b.cmp(a));
            set2.append(new_array);
            finalset = replace_fourteen(set2.to_vec());
        } else {
            //println!("new_array {:?}", new_array);
            //new_array.sort_by(|a, b| b.cmp(a));
            set1.append(new_array);
            finalset = replace_fourteen(set1.to_vec());
        }
    } else {
        /* CASE 3:
          3a: player 2 draws card with higher rank
          3b: player 1 draws card with higher rank
          3c: both cards have same rank
        */
        let index = 0;
        if let (Some(&elem1), Some(&elem2)) = (set1.get(index), set2.get(index)) {
            if elem1 < elem2 {
                new_array.push(elem1);
                new_array.push(elem2);
                new_array.sort_by(|a, b| b.cmp(a));
                set2.append(new_array);
                set1.remove(index);
                set2.remove(index);
                return pull_cards(set1, set2, new_array);
            } else if elem1 > elem2 {
                new_array.push(elem1);
                new_array.push(elem2);
                new_array.sort_by(|a, b| b.cmp(a));
                set1.append(new_array);
                set1.remove(index);
                set2.remove(index);
                return pull_cards(set1, set2, new_array);
            } else {
                /* CASE 3:
                  3c.1: one player has only 1 remaining card (recursion exit case)
                  3c.2: either player has >1 but <=3 cards 
                */
                if set1.len() == 1 || set2.len() == 1
                {
                  let index = 0;
                  new_array.push(elem1);
                  new_array.push(elem2);
                  new_array.sort_by(|a, b| b.cmp(a));
                  set1.remove(index);
                  set2.remove(index);
                  return pull_cards(set1, set2, new_array);
                }
                else 
                {
                let index = 2;
                new_array.extend_from_slice(&set1[..index]);
                new_array.extend_from_slice(&set2[..index]);
                new_array.sort_by(|a, b| b.cmp(a));
                set1.drain(..index);
                set2.drain(..index);
                return pull_cards(set1, set2, new_array);
                }
            }
        }
    }
    finalset
}

/* deal takes a [u8;52] array, reverses it and converts it into a Vec<u8>. Then, all the 1s in the vector are replaced with 14s. After which, the vector is split into two vectors, one for each player. 
In pull_cards, the cards are pulled from each player's set and the game is played.
The winning hand is returned.
*/
fn deal(shuf: &mut [u8; 52]) -> [u8; 52] {
    shuf.reverse(); // Reverse the array in place

    let mut new_array = Vec::new();
    let (mut even_indices, mut odd_indices) = split_alternatively(replace_ones(shuf.to_vec()));
    let result = pull_cards(&mut even_indices, &mut odd_indices, &mut new_array);

    let mut shuf_52: [u8; 52] = [0; 52];
    shuf_52.copy_from_slice(&result);

    shuf_52
}


#[cfg(test)]
#[path = "tests.rs"]
mod tests;