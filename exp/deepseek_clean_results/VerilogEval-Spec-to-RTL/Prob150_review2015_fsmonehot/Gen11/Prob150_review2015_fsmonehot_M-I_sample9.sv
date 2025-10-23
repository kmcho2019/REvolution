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

    // Next state logic - optimized direct state bit usage
    assign S_next = (state[0] | state[1] | state[3]) & ~d | (state[9] & ack);
    assign S1_next = state[0] & d;
    assign B3_next = state[6];  // B2 -> B3
    
    // Counting state transitions - optimized
    assign Count_next = state[7] | (state[8] & ~done_counting);
    assign Wait_next = (state[8] & done_counting) | (state[9] & ~ack);

    // Output logic - direct state bit assignments
    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = state[4] | state[5] | state[6] | state[7];  // B0-B3

endmodule