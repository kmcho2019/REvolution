module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Next-state logic
assign B3_next = (state == 10'b0000000100 && d == 1) ||
                 (state == 10'b0000001000); // B2 -> B3
assign S_next = (state == 10'b0000000001 && d == 0) ||
                (state == 10'b0000000010 && d == 0) ||
                (state == 10'b0000000100 && d == 0) ||
                (state == 10'b1000000000 && ack == 1); // S1, S11, S110, Wait -> S
assign S1_next = (state == 10'b0000000001 && d == 1); // S -> S1
assign Count_next = (state == 10'b0000010000 && d == 1); // B3 -> Count
assign Wait_next = (state == 10'b0000010000 && done_counting == 1); // Count -> Wait

// Output logic
assign done = state[9]; // Wait
assign counting = state[8]; // Count
assign shift_ena = state[5] || state[6] || state[7] || state[4]; // B0, B1, B2, B3

endmodule