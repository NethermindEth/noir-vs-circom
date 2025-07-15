// https://github.com/tornadocash/tornado-core/blob/master/circuits/merkleTree.circom

pragma circom 2.1.5;

include "node_modules/circomlib/circuits/poseidon.circom";

template Merkleverifier(N) {
    signal input leaf;
    signal input root;
    signal input path[N];
    signal input pathIndex[N];

    component hasher[N];
    component mux[N];

    for (var i = 0; i < N; i++) {
        mux[i] = DualMux();
        mux[i].in[0] <== i == 0 ? leaf : hasher[i - 1].out;
        mux[i].in[1] <== path[i];
        mux[i].s <== pathIndex[i];

        hasher[i] = hash_lr();
        hasher[i].left <== mux[i].out[0];
        hasher[i].right <== mux[i].out[1];
    }
    root === hasher[N - 1].out;
}

template DualMux() {
    signal input in[2];
    signal input s;
    signal output out[2];

    s * (1 - s) === 0;
    out[0] <== (in[1] - in[0])*s + in[0];
    out[1] <== (in[0] - in[1])*s + in[1];
}

template hash_lr() {
    signal input left;
    signal input right;
    signal output out;
    component poseidon = Poseidon(2);
    poseidon.inputs[0] <== left;
    poseidon.inputs[1] <== right;
    out <== poseidon.out; 
}

component main = Merkleverifier(2);