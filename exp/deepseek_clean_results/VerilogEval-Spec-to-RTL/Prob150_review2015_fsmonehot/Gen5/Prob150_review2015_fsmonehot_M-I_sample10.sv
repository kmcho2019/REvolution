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

    // Next state logic - optimized for timing
    wire S_from_S = state[0] & ~d;
    wire S_from_S1 = state[1] & ~d;
    wire S_from_S110 = state[3] & ~d;
    wire S_from_Wait = state[9] & ack;
    assign S_next = S_from_S | S_from_S1 | S_from_S110 | S_from_Wait;

    assign S1_next = state[0] & d;  // Only S->S1 transition

    assign B3_next = state[6];      // B2 always goes to B3

    wire Count_from_B3 = state[7];
    wire Count_from_Count = state[8] & ~done_counting;
    assign Count_next = Count_from_B3 | Count_from_Count;

    wire Wait_from_Count = state[8] & done_counting;
    wire Wait_from_Wait = state[9] & ~ack;
    assign Wait_next = Wait_from_Count | Wait_from_Wait;

    // Output logic - optimized for area and power
    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = state[4] | state[5] | state[6] | state[7];  // B0-B3 states

endmodule