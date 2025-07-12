module TopModule(
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

// Next state logic
assign B3_next = (state == 10'b0000001000);
assign S_next = (state == 10'b0000000001) & ~d | (state == 10'b0000000010) & ~d | (state == 10'b0000000100) & ~d | (state == 10'b1000000000) & ack;
assign S1_next = (state == 10'b0000000001) & d;
assign Count_next = (state == 10'b0000010000) & done_counting;
assign Wait_next = (state == 10'b0000010000) & ~done_counting | (state == 10'b1000000000) & ~ack;

// Output logic
assign done = (state == 10'b1000000000);
assign counting = (state == 10'b0000010000);
assign shift_ena = (state[3:0] == 4'b1000) | (state[3:0] == 4'b1001) | (state[3:0] == 4'b1010) | (state[3:0] == 4'b1011);

endmodule