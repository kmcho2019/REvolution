module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot: [S, S1, S11, S110, B0, B1, B2, B3, Count, Wait]
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Next state logic
    assign S_next = (~d & (state[0] | state[1] | state[3])) | (state[9] & ack);
    assign S1_next = state[0] & d;
    assign B3_next = state[6];  // B2->B3
    assign Count_next = state[7] | (state[8] & ~done_counting);  // B3->Count or Count stays
    assign Wait_next = (state[8] & done_counting) | (state[9] & ~ack);  // Count->Wait or Wait stays

    // Output logic
    assign shift_ena = state[4];  // Only need to check B0 since states are sequential
    assign counting = state[8];   // Count state
    assign done = state[9];       // Wait state

endmodule