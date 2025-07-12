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

// Next-state logic equations
assign B3_next = (state == 10'b0000000100 && d == 1) ||  // S11 -> B3
                 (state == 10'b0000000010 && d == 0) ||  // S1 -> S
                 (state == 10'b0000001000 && d == 1) ||  // S110 -> B0
                 (state == 10'b0000010000 && d == 0) ||  // B0 -> B1
                 (state == 10'b0000100000 && d == 0) ||  // B1 -> B2
                 (state == 10'b0001000000 && d == 0);   // B2 -> B3

assign S_next = (state == 10'b0000000001 && d == 0) ||  // S -> S
                (state == 10'b0000000010 && d == 0) ||  // S1 -> S
                (state == 10'b1000000000 && ack == 1);  // Wait -> S

assign S1_next = (state == 10'b0000000001 && d == 1);  // S -> S1

assign Count_next = (state == 10'b0001000000 && d == 0) ||  // B3 -> Count
                    (state == 10'b0010000000 && done_counting == 0);  // Count -> Count

assign Wait_next = (state == 10'b0010000000 && done_counting == 1);  // Count -> Wait

// Output logic equations
assign shift_ena = (state == 10'b0000010000) ||  // B0
                   (state == 10'b0000100000) ||  // B1
                   (state == 10'b0001000000) ||  // B2
                   (state == 10'b0010000000);   // B3

assign counting = (state == 10'b0010000000);  // Count

assign done = (state == 10'b1000000000);  // Wait

endmodule