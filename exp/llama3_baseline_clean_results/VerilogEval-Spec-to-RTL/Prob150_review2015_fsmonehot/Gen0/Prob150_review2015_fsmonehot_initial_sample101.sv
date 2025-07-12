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
assign B3_next = (state[9:0] == 10'b0000001000) && d; // Transition to B3 from B2
assign S_next  = (state[9:0] == 10'b0000000001 && !d) || 
                 (state[9:0] == 10'b0000000010 && !d) || 
                 (state[9:0] == 10'b0000000100 && !d) || 
                 (state[9:0] == 10'b0000001000 && !d) || 
                 (state[9:0] == 10'b1000000000 && ack); // Transition to S from S, S1, S11, S110, or Wait
assign S1_next = (state[9:0] == 10'b0000000001 && d); // Transition to S1 from S
assign Count_next = (state[9:0] == 10'b0000010000); // Transition to Count from B3
assign Wait_next = (state[9:0] == 10'b0000001000 && done_counting); // Transition to Wait from Count

// Output logic
assign shift_ena = (state[9:0] == 10'b0000000001) || 
                   (state[9:0] == 10'b0000000010) || 
                   (state[9:0] == 10'b0000000100) || 
                   (state[9:0] == 10'b0000001000); // Assert shift_ena in B0, B1, B2, B3 states
assign counting = (state[9:0] == 10'b0000010000); // Assert counting in Count state
assign done = (state[9:0] == 10'b1000000000); // Assert done in Wait state

endmodule