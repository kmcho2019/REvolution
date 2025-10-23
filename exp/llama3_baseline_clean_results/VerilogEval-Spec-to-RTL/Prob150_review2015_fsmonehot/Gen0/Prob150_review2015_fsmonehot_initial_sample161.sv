module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoded state
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
assign B3_next = (state[9:0] == 10'b0000000100 && d == 1) ||  // S11 -> B3 (not possible)
                 (state[9:0] == 10'b0000000010 && d == 0) ||  // S1 -> S (not possible)
                 (state[9:0] == 10'b0000001000 && d == 1) ||  // S110 -> B0
                 (state[9:0] == 10'b0000010000 && d == 1) ||  // B0 -> B1
                 (state[9:0] == 10'b0000100000 && d == 1) ||  // B1 -> B2
                 (state[9:0] == 10'b0001000000 && d == 1) ||  // B2 -> B3
                 (state[9:0] == 10'b0010000000 && d == 1);    // B3 -> Count
assign S_next = (state[9:0] == 10'b1000000000 && d == 0) ||  // S -> S
                (state[9:0] == 10'b0000000010 && d == 0) ||  // S1 -> S
                (state[9:0] == 10'b0000000100 && d == 0) ||  // S11 -> S110
                (state[9:0] == 10'b0000001000 && d == 0) ||  // S110 -> S
                (state[9:0] == 10'b1000000000 && ack == 1);   // Wait -> S
assign S1_next = (state[9:0] == 10'b1000000000 && d == 1);   // S -> S1
assign Count_next = (state[9:0] == 10'b0010000000 && done_counting == 0) ||  // Count -> Count
                    (state[9:0] == 10'b0001000000 && d == 1);  // B3 -> Count
assign Wait_next = (state[9:0] == 10'b0010000000 && done_counting == 1);  // Count -> Wait

// Output logic
assign shift_ena = (state[9:0] == 10'b0000010000) ||  // B0
                   (state[9:0] == 10'b0000100000) ||  // B1
                   (state[9:0] == 10'b0001000000) ||  // B2
                   (state[9:0] == 10'b0010000000);    // B3
assign counting = (state[9:0] == 10'b0010000000);  // Count
assign done = (state[9:0] == 10'b0100000000);      // Wait

endmodule