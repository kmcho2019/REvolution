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
assign B3_next = (state == 10'b0000000100 && d == 1) || (state == 10'b0000001000 && d == 0);
assign S_next = (state == 10'b0000000001 && d == 0) || (state == 10'b0000000010 && d == 0) || (state == 10'b0000001000 && d == 0) || (state == 10'b1000000000 && ack == 1);
assign S1_next = (state == 10'b0000000001 && d == 1);
assign Count_next = (state == 10'b0000010000 && done_counting == 1);
assign Wait_next = (state == 10'b0000010000 && done_counting == 0) || (state == 10'b1000000000 && ack == 0);

// Output logic equations
assign shift_ena = (state == 10'b0000001000) || (state == 10'b0000010000) || (state == 10'b0000100000) || (state == 10'b0001000000) || (state == 10'b0010000000);
assign counting = (state == 10'b0000010000);
assign done = (state == 10'b1000000000);

endmodule