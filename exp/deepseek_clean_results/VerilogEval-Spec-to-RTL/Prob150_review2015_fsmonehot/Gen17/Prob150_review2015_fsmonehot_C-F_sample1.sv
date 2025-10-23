module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot: S(0), S1(1), S11(2), S110(3),
                        // B0(4), B1(5), B2(6), B3(7), Count(8), Wait(9)
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // State transitions with optimized common terms
    wire to_S = (state[0] | state[1] | state[3]) & ~d;
    wire to_S_from_Wait = state[9] & ack;
    assign S_next = to_S | to_S_from_Wait;
    
    assign S1_next = state[0] & d;
    assign B3_next = state[6];  // B2 always goes to B3

    wire count_active = state[8];
    assign Count_next = state[7] | (count_active & ~done_counting);
    assign Wait_next = (count_active & done_counting) | (state[9] & ~ack);

    // Output logic - direct from state bits
    assign shift_ena = state[4] | state[5] | state[6] | state[7];  // B0-B3
    assign counting = state[8];  // Count state
    assign done = state[9];      // Wait state
endmodule