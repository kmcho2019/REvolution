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

assign B3_next = (state == 10'b0000010000); // current state is B2
assign S_next = (state == 10'b0000000001 && ~d) || (state == 10'b0000000010 && ~d) || (state == 10'b0000000100 && ~d) || (state == 10'b1000000000 && ack); // current state is S and d = 0, or current state is S1 and d = 0, or current state is S110 and d = 0, or current state is Wait and ack = 1
assign S1_next = (state == 10'b0000000001 && d); // current state is S and d = 1
assign Count_next = (state == 10'b0000001000); // current state is B3
assign Wait_next = (state == 10'b0000100000 && done_counting); // current state is Count and done_counting = 1

assign done = (state == 10'b1000000000); // current state is Wait
assign counting = (state == 10'b0000100000); // current state is Count
assign shift_ena = (state == 10'b0000001000) || (state == 10'b0000010000) || (state == 10'b0000100000) || (state == 10'b0001000000); // current state is B0, B1, B2, or B3

endmodule