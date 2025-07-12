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
assign B3_next = (state[4] == 1'b1) && (1'b1); // Always go to B3 from B2
assign S_next  = (state[0] == 1'b1) && (d == 1'b0) || (state[1] == 1'b1) && (d == 1'b0) || (state[3] == 1'b1) && (d == 1'b0) || (state[9] == 1'b1) && (ack == 1'b1);
assign S1_next = (state[0] == 1'b1) && (d == 1'b1) || (state[1] == 1'b1) && (d == 1'b0);
assign Count_next = (state[7] == 1'b1) || (state[6] == 1'b1) && (1'b1); // Always go to Count from B3
assign Wait_next = (state[7] == 1'b1) && (done_counting == 1'b1);

// Output logic equations
assign shift_ena = (state[4] == 1'b1) || (state[5] == 1'b1) || (state[6] == 1'b1) || (state[7] == 1'b1);
assign counting = (state[7] == 1'b1);
assign done    = (state[8] == 1'b1);

endmodule