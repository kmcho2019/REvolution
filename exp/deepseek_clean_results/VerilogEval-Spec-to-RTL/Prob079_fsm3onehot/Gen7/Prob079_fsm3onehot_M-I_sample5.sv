module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    wire in_n = ~in;  // Common subexpression elimination
    
    // Optimized state transition logic
    assign next_state[0] = in_n & (state[0] | state[2]);  // A
    assign next_state[1] = in | (in_n & state[1]);        // B - rewritten to use OR
    assign next_state[2] = in_n & (state[1] | state[3]);  // C
    assign next_state[3] = in & state[2];                 // D
    
    // Output remains optimal
    assign out = state[3];

endmodule