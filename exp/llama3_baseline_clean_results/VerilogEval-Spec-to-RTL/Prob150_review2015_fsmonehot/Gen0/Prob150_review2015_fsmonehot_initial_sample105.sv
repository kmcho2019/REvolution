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

// one-hot encoding: (S, S1, S11, S110, B0, B1, B2, B3, Count, Wait)
// = (10'b0000000001, 10'b0000000010, 10'b0000000100, ... , 10'b1000000000)

// next-state logic
assign B3_next = (state[0] && d && ~d) || (state[1] && d && ~d) || (state[2] && d && ~d) || (state[3] && ~d && d) || 
                (state[3] && d && d) || (state[4] && 1'b1) || (state[5] && 1'b1) || (state[6] && 1'b1) || (state[7] && 1'b1);
assign S_next = (state[0] && ~d) || (state[1] && ~d) || (state[3] && ~d) || (state[9] && ack);
assign S1_next = (state[0] && d);
assign Count_next = (state[7] && 1'b1 && done_counting);
assign Wait_next = (state[7] && done_counting);

// output logic
assign shift_ena = state[4] || state[5] || state[6] || state[7];
assign counting = state[8];
assign done = state[9];

endmodule