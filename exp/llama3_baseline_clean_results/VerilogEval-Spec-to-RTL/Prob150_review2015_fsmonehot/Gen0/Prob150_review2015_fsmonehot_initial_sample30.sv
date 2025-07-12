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
assign B3_next = (state == 10'b0000001000 && d == 1) || 
                 (state == 10'b0000000100); // Transition to B3 from B2 or stay in B3 if not transitioning

assign S_next = (state == 10'b0000000001 && d == 0) || 
                (state == 10'b0000000010 && d == 0) || 
                (state == 10'b0000000100 && d == 0) || 
                (state == 10'b1000000000 && ack == 1); // Transition to S from S, S1, S110, or Wait

assign S1_next = (state == 10'b0000000001 && d == 1); // Transition to S1 from S

assign Count_next = (state == 10'b0000010000 && done_counting == 1); // Transition to Count from B3

assign Wait_next = (state == 10'b0000010000 && done_counting == 0); // Transition to Wait from Count

// Output logic
assign shift_ena = (state == 10'b0000000100) || (state == 10'b0000001000) || 
                   (state == 10'b0010000000) || (state == 10'b0100000000); // shift_ena is high in B0, B1, B2, B3

assign counting = (state == 10'b1000000000); // counting is high in Count state

assign done = (state == 10'b1000000000); // done is high in Wait state

endmodule