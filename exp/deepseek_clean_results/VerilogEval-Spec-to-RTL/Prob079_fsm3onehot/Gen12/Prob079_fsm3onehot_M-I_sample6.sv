module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    wire in_n = ~in;
    
    // Optimized state transition logic
    assign next_state[3] = in & state[2];          // D: from C when in=1
    assign next_state[2] = in_n & (state[1] | state[3]); // C: from B/D when in=0
    assign next_state[1] = in & (state[0] | state[1] | state[3]); // B: from A/B/D when in=1
    assign next_state[0] = in_n & (state[0] | state[2]); // A: from A/C when in=0

    // Output remains direct assignment
    assign out = state[3];

endmodule