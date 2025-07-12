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
assign B3_next = (state == 10'b0000100000); // B2
assign S_next = (state == 10'b0000000001 && d == 1'b0) ||
                (state == 10'b0000000010 && d == 1'b0) ||
                (state == 10'b0000001000 && d == 1'b0) ||
                (state == 10'b1000000000 && ack == 1'b1);
assign S1_next = (state == 10'b0000000001 && d == 1'b1) ||
                 (state == 10'b0000000010 && d == 1'b0) ||
                 (state == 10'b0000000100 && d == 1'b0);
assign Count_next = (state == 10'b0001000000); // B3
assign Wait_next = (state == 10'b0100000000);

// Define output logic
assign shift_ena = (state == 10'b0000010000) || // B0
                   (state == 10'b0000100000) || // B1
                   (state == 10'b0001000000) || // B2
                   (state == 10'b0010000000); // B3
assign counting = (state == 10'b0100000000); // Count
assign done = (state == 10'b1000000000); // Wait

endmodule