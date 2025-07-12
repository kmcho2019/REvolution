module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State transition logic optimized for one-hot encoding:
    // A (state[0]): from A or C when in=0
    assign next_state[0] = ~in & (state[0] | state[2]);
    
    // B (state[1]): from A, B, or D when in=1 (simplified using one-hot)
    assign next_state[1] = in & ~state[2];
    
    // C (state[2]): from B or D when in=0
    assign next_state[2] = ~in & (state[1] | state[3]);
    
    // D (state[3]): from C when in=1
    assign next_state[3] = in & state[2];

    // Output is high only in state D (one-hot MSB)
    assign out = state[3];

endmodule