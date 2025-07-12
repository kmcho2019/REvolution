module TopModule(
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
assign B3_next = (state[9:0] == 10'b0000000100) && d; // S11 -> B3 not possible, B2 -> B3
assign B3_next = B3_next || (state[9:0] == 10'b0000010000); // B2 -> B3

assign S_next = (state[9:0] == 10'b1000000000) && ack; // Wait -> S
assign S_next = S_next || (state[9:0] == 10'b0000000001) && !d; // S -> S
assign S_next = S_next || (state[9:0] == 10'b0000000010) && !d; // S1 -> S
assign S_next = S_next || (state[9:0] == 10'b0000001000) && !d; // S110 -> S

assign S1_next = (state[9:0] == 10'b0000000001) && d; // S -> S1

assign Count_next = (state[9:0] == 10'b0000100000) && done_counting; // B3 -> Count

assign Wait_next = (state[9:0] == 10'b0000100000) && !done_counting; // Count -> Wait
assign Wait_next = Wait_next || (state[9:0] == 10'b1000000000) && !ack; // Wait -> Wait

// Output logic
assign done = (state[9:0] == 10'b1000000000); // Wait
assign counting = (state[9:0] == 10'b0000100000); // Count
assign shift_ena = (state[9:0] == 10'b0000001000) || // B0
                  (state[9:0] == 10'b0000010000) || // B1
                  (state[9:0] == 10'b0000100000) || // B2
                  (state[9:0] == 10'b0001000000); // B3

endmodule