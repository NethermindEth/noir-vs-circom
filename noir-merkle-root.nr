// https://github.com/tomoima525/noir-merkle-root/blob/main/src/lib.nr

use dep::std;

// Returns the merkle root of the tree from the provided leaf, path indices, siblings with poseidon hash.
fn compute_merkle_root(root: Field, leaf: Field, path_indices: [Field], siblings: [Field]) {
    let n = siblings.len();
    let mut current = leaf;
    for i in 0..n {
        let is_right = (path_indices[i] == 1) as bool;
        let (hash_left, hash_right) = if is_right {
            (siblings[i], current)
         } else {
            (current, siblings[i])
         };
      current = std::hash::poseidon::bn254::hash_2([hash_left, hash_right]);
    };
    assert(current == root)
}