module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // State decoder
    wire [9:0] decoded_state;
    assign decoded_state[0] = state[0]; // S
    assign decoded_state[1] = state[1]; // S1
    assign decoded_state[2] = state[2]; // S11
    assign decoded_state[3] = state[3]; // S110
    assign decoded_state[4] = state[4]; // B0
    assign decoded_state[5] = state[5]; // B1
    assign decoded_state[6] = state[6]; // B2
    assign decoded_state[7] = state[7]; // B3
    assign decoded_state[8] = state[8]; // Count
    assign decoded_state[9] = state[9]; // Wait

    // Next-state logic
    wire next_S, next_S1, next_S11, next_S110, next_B0, next_B1, next_B2, next_B3, next_Count, next_Wait;
    assign next_S = (decoded_state[0] && ~d) || (decoded_state[1] && ~d) || (decoded_state[3] && ~d) || (decoded_state[9] && ack);
    assign next_S1 = decoded_state[0] && d;
    assign next_S11 = decoded_state[1] && d;
    assign next_S110 = decoded_state[2] && ~d;
    assign next_B0 = decoded_state[3] && d;
    assign next_B1 = decoded_state[4];
    assign next_B2 = decoded_state[5];
    assign next_B3 = decoded_state[6];
    assign next_Count = decoded_state[7] || (decoded_state[8] && ~done_counting);
    assign next_Wait = (decoded_state[8] && done_counting) || (decoded_state[9] && ~ack);

    // Output logic
    assign done = decoded_state[9];
    assign counting = decoded_state[8];
    assign shift_ena = decoded_state[4] || decoded_state[5] || decoded_state[6] || decoded_state[7];

    // Next-state outputs
    assign B3_next = next_B3;
    assign S_next = next_S;
    assign S1_next = next_S1;
    assign Count_next = next_Count;
    assign Wait_next = next_Wait;

endmodule