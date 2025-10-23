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

    // State decoding with direct output assignments
    assign done = state[9];  // Wait state
    assign counting = state[8];  // Count state
    assign shift_ena = |state[6:4];  // B0-B3 states

    // Optimized next-state logic with shared expressions
    wire from_S = state[0];
    wire from_S1 = state[1];
    wire from_S110 = state[3];
    wire from_Wait = state[9];
    wire from_Count = state[8];
    wire from_B2 = state[6];
    wire from_B3 = state[7];

    // Common transition patterns
    wire to_S = (from_S & ~d) | (from_S1 & ~d) | (from_S110 & ~d) | (from_Wait & ack);
    wire to_S1 = from_S & d;
    wire to_Count = from_B3 | (from_Count & ~done_counting);
    wire to_Wait = from_Count & done_counting;

    assign S_next = to_S;
    assign S1_next = to_S1;
    assign B3_next = from_B2;
    assign Count_next = to_Count;
    assign Wait_next = to_Wait | (from_Wait & ~ack);

endmodule