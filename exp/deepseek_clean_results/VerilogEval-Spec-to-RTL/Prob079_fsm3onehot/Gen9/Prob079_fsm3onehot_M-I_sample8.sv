module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    assign next_state[0] = ~in & (state[0] | state[2]);  // A: stays same (already minimal)
    assign next_state[1] = in & ~state[2];               // B: stays same (optimal)
    assign next_state[2] = ~in & (state[1] | state[3]);  // C: stays same (already minimal)
    assign next_state[3] = in & state[2];                // D: stays same (optimal)
    
    assign out = state[3];                              // Output: stays same (optimal)

endmodule