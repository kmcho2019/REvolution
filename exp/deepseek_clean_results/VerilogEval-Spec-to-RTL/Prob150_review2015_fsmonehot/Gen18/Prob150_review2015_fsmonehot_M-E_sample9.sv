module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Unified next state computation
    wire [9:0] next_state;
    
    // Pattern detection states (S, S1, S11, S110)
    assign next_state[0] = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack);
    assign next_state[1] = (state[0] & d);
    assign next_state[2] = (state[1] & d);
    assign next_state[3] = (state[2] & ~d);
    
    // Bit shifting states (B0-B3)
    assign next_state[4] = state[3] & d;
    assign next_state[5] = state[4];
    assign next_state[6] = state[5];
    assign next_state[7] = state[6];
    
    // Counting states
    assign next_state[8] = state[7] | (state[8] & ~done_counting);
    assign next_state[9] = (state[8] & done_counting) | (state[9] & ~ack);

    // Individual next state outputs
    assign S_next = next_state[0];
    assign S1_next = next_state[1];
    assign B3_next = next_state[7];
    assign Count_next = next_state[8];
    assign Wait_next = next_state[9];

    // Output logic - direct state bit checks
    assign shift_ena = |state[7:4];  // B0-B3 states
    assign counting = state[8];      // Count state
    assign done = state[9];          // Wait state

endmodule