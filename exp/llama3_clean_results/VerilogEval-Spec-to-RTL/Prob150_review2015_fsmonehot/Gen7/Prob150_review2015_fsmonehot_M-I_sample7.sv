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

// Define next-state logic
assign B3_next = (state == 10'b0001000000); // B3
assign S_next = (state == 10'b0000000001 && !d) ||
                (state == 10'b0000000010 && !d) ||
                (state == 10'b0000001000 && !d) ||
                (state == 10'b1000000000 && ack);
assign S1_next = (state == 10'b0000000001 && d) ||
                 (state == 10'b0000000100 && !d);
assign Count_next = (state == 10'b0000010000 && d) ||
                    (state == 10'b0010000000 && !done_counting);
assign Wait_next = (state == 10'b0010000000 && done_counting) ||
                   (state == 10'b1000000000 && !ack);

// Define output logic
assign shift_ena = (state[5] || state[6] || state[7] || state[4]); // B0, B1, B2, B3
assign counting = state[8]; // Count
assign done = state[9]; // Wait

endmodule