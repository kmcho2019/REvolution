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
    assign B3_next = (state[9:0] == 10'b0000010000) & d & ~done_counting;
    assign S_next = (state[9:0] == 10'b0000000001) & ~d | (state[9:0] == 10'b0000000010) & ~d | (state[9:0] == 10'b0000000100) & ~d | (state[9:0] == 10'b1000000000) & ack;
    assign S1_next = (state[9:0] == 10'b0000000001) & d;
    assign Count_next = (state[9:0] == 10'b0000001000) & done_counting;
    assign Wait_next = (state[9:0] == 10'b0000001000) & ~done_counting | (state[9:0] == 10'b1000000000) & ~ack;

    // Output logic
    assign shift_ena = state[9:0] == 10'b0000010000 | state[9:0] == 10'b0000001000 | state[9:0] == 10'b0000000100 | state[9:0] == 10'b0000000010;
    assign counting = state[9:0] == 10'b0000001000;
    assign done = state[9:0] == 10'b1000000000;

endmodule