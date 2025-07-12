module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Optimized next state logic without intermediate wires
    assign next_state[0] = (state[0] | state[2]) & ~in;  // A: from A or C when in=0
    assign next_state[1] = in & (state[0] | state[1] | state[3]); // B: from A,B,D when in=1
    assign next_state[2] = (state[1] | state[3]) & ~in;  // C: from B or D when in=0
    assign next_state[3] = state[2] & in;                // D: from C when in=1

    // Direct output assignment
    assign out = state[3];

endmodule