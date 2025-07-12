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

// next state logic
assign B3_next = (state[9:0] == 10'b0000001000) ||  // current state is B2
                 (state[9:0] == 10'b0000010000);  // current state is B3

assign S_next = (state[9:0] == 10'b0000000001 && d == 0) ||  // current state is S and d=0
                (state[9:0] == 10'b0000000010 && d == 0) ||  // current state is S1 and d=0
                (state[9:0] == 10'b0000000100 && d == 0) ||  // current state is S11 and d=0
                (state[9:0] == 10'b1000000000 && ack == 1);  // current state is Wait and ack=1

assign S1_next = (state[9:0] == 10'b0000000001 && d == 1);  // current state is S and d=1

assign Count_next = (state[9:0] == 10'b0000000001 && d == 1 && d == 1 && d == 1 && d == 1) ||  // current state is S and d=1 four times
                    (state[9:0] == 10'b0000001000);  // current state is B3

assign Wait_next = (state[9:0] == 10'b0000010000 && done_counting == 1);  // current state is Count and done_counting=1

// output logic
assign shift_ena = (state[9:0] == 10'b0000000101) ||  // current state is B0
                   (state[9:0] == 10'b0000001000) ||  // current state is B1
                   (state[9:0] == 10'b0000010000) ||  // current state is B2
                   (state[9:0] == 10'b0000010001);  // current state is B3

assign counting = (state[9:0] == 10'b0000010010);  // current state is Count

assign done = (state[9:0] == 10'b1000000000);  // current state is Wait

endmodule