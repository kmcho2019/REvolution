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

// Current state to next state logic
assign B3_next = (state[4] == 1'b1);  // Next state is B3 when current state is B3
assign S_next = (state[0] == 1'b1 && d == 1'b0) || 
                (state[1] == 1'b1 && d == 1'b0) || 
                (state[3] == 1'b1 && d == 1'b0) || 
                (state[9] == 1'b1 && ack == 1'b1);  // Next state is S
assign S1_next = (state[0] == 1'b1 && d == 1'b1);  // Next state is S1
assign Count_next = (state[4] == 1'b1 && done_counting == 1'b1) || 
                    (state[8] == 1'b1 && done_counting == 1'b1);  // Next state is Count
assign Wait_next = (state[8] == 1'b1 && done_counting == 1'b1);  // Next state is Wait

// Output logic
assign shift_ena = state[4] || state[5] || state[6] || state[7];  // Shift enable when in B0, B1, B2, or B3 state
assign counting = state[8];  // Counting when in Count state
assign done = state[9];  // Done when in Wait state

endmodule