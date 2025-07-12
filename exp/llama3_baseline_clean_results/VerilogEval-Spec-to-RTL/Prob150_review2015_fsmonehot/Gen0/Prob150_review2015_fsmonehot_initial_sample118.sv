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

    assign B3_next = (state[7] == 1'b1);
    assign S_next = (state[0] == 1'b1);
    assign S1_next = (state[1] == 1'b1);
    assign Count_next = (state[8] == 1'b1);
    assign Wait_next = (state[9] == 1'b1);

    assign done = (state[9] == 1'b1);
    assign counting = (state[8] == 1'b1);
    assign shift_ena = (state[4] == 1'b1 || state[5] == 1'b1 || state[6] == 1'b1 || state[7] == 1'b1);

endmodule