module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // next-state logic
    assign B3_next = (state[9:0] == 10'b0000001000) && d;
    assign S_next = ((state[9:0] == 10'b1000000000 && d == 1'b0) || 
                    (state[9:0] == 10'b0000000010 && d == 1'b0) || 
                    (state[9:0] == 10'b0000000100 && d == 1'b0) || 
                    (state[9:0] == 10'b0000001000 && done_counting) || 
                    (state[9:0] == 10'b1000000000 && ack));
    assign S1_next = (state[9:0] == 10'b1000000000 && d);
    assign Count_next = (state[9:0] == 10'b0000000001 && done_counting);
    assign Wait_next = ((state[9:0] == 10'b0000000001 && !done_counting) || 
                       (state[9:0] == 10'b0000001000 && ack));

    // output logic
    assign done = (state[9:0] == 10'b1000000000);
    assign counting = (state[9:0] == 10'b0000000001);
    assign shift_ena = (state[9:0] == 10'b0000000100) || 
                       (state[9:0] == 10'b0000001000) || 
                       (state[9:0] == 10'b0000001000);

endmodule