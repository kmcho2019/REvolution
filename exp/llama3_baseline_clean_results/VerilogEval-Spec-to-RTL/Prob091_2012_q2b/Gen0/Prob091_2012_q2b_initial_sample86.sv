module TopModule(
    input [5:0] y, // current state
    input w,      // input to the FSM
    output Y1,    // input to state flip-flop y[1]
    output Y3     // input to state flip-flop y[3]
);

// Determine next state based on current state and input w
// Since the encoding is one-hot, we can directly check the bits
// For each possible next state, we OR the conditions that lead to it

// Next state is B (000010) if current state is A (000001) and w is 1
// or if current state is F (100000) and w is 1
assign Y1 = (y[0] && w) || (y[5] && w);

// Next state is C (000100) if current state is B (000010) and w is 1
// or if current state is F (100000) and w is 1
assign Y3 = (y[1] && w) || (y[5] && w);

endmodule