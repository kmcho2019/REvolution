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

// Next-state logic
assign B3_next = (state[3] == 1'b1); // Next state is B3
assign S_next = (state[0] == 1'b1 && d == 1'b0) || 
                (state[1] == 1'b1 && d == 1'b0) || 
                (state[3] == 1'b1 && d == 1'b0 && done_counting == 1'b0 && ack == 1'b1) || 
                (state[8] == 1'b1 && ack == 1'b1);
assign S1_next = (state[0] == 1'b1 && d == 1'b1);
assign Count_next = (state[4] == 1'b1 && done_counting == 1'b1);
assign Wait_next = (state[4] == 1'b1 && done_counting == 1'b1) || 
                   (state[9] == 1'b1 && ack == 1'b0);

// Output logic
assign done = state[9];
assign counting = state[4];
assign shift_ena = state[5] || state[6] || state[7] || state[3];

endmodule