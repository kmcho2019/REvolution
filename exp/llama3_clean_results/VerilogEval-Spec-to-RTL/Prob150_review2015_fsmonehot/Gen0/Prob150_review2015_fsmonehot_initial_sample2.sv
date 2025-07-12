module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // One-hot encoding: (S, S1, S11, S110, B0, B1, B2, B3, Count, Wait)
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
assign B3_next = (state[9:0] == 10'b0000001000) | 
                 (state[9:0] == 10'b0000010000) & ~d;

assign S_next = (state[9:0] == 10'b1000000000) & ack | 
                (state[9:0] == 10'b0000000100) & ~d;

assign S1_next = (state[9:0] == 10'b0000000001) & d;

assign Count_next = (state[9:0] == 10'b0000100000);

assign Wait_next = (state[9:0] == 10'b0100000000) & ~ack | 
                   (state[9:0] == 10'b0000100000) & done_counting;

// Output logic
assign done = state[9:0] == 10'b0100000000;
assign counting = state[9:0] == 10'b0000100000;
assign shift_ena = (state[9:0] == 10'b0010000000) | 
                   (state[9:0] == 10'b0001000000) | 
                   (state[9:0] == 10'b0000100000) | 
                   (state[9:0] == 10'b0000010000);

endmodule