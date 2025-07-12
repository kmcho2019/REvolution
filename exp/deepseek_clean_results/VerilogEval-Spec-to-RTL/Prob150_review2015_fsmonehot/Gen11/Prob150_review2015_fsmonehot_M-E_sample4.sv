module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // Maintain original interface
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // State prediction wires (parallel next state calculation)
    wire next_S = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack);
    wire next_S1 = state[0] & d;
    wire next_S11 = state[1] & d;
    wire next_S110 = state[2] & ~d;
    wire next_B0 = state[3] & d;
    wire next_B1 = state[4];
    wire next_B2 = state[5];
    wire next_B3 = state[6];
    wire next_Count = state[7] | (state[8] & ~done_counting);
    wire next_Wait = (state[8] & done_counting) | (state[9] & ~ack);

    // Next state outputs
    assign S_next = next_S;
    assign S1_next = next_S1;
    assign B3_next = next_B3;
    assign Count_next = next_Count;
    assign Wait_next = next_Wait;

    // Output logic with parallel prediction
    assign done = state[9] | next_Wait;  // Early done prediction
    assign counting = state[8] | next_Count;  // Early counting prediction
    
    // Shift enable activates one cycle early during B-state transitions
    assign shift_ena = |state[6:4] | next_B0 | next_B1 | next_B2 | next_B3;

endmodule