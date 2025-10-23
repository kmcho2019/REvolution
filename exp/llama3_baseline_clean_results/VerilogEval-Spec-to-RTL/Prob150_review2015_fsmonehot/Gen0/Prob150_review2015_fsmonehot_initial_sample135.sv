module TopModule (
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

// State transition logic
assign S_next = ~state[9] & ~state[8] & ~state[7] & ~state[6] & ~state[5] & ~state[4] & ~state[3] & ~state[2] & ~state[1] & state[0] & ~d |
               ~state[9] & ~state[8] & ~state[7] & ~state[6] & ~state[5] & ~state[4] & ~state[3] & ~state[2] & state[1] & ~state[0] & ~d |
               ~state[9] & ~state[8] & ~state[7] & ~state[6] & ~state[5] & ~state[4] & ~state[3] & state[2] & ~state[1] & ~state[0] & ~d;

assign S1_next = ~state[9] & ~state[8] & ~state[7] & ~state[6] & ~state[5] & ~state[4] & ~state[3] & ~state[2] & ~state[1] & state[0] & d;

assign B3_next = ~state[9] & ~state[8] & ~state[7] & ~state[6] & ~state[5] & state[4] & ~state[3] & ~state[2] & ~state[1] & ~state[0];

assign Count_next = ~state[9] & state[8] & ~state[7] & ~state[6] & ~state[5] & ~state[4] & ~state[3] & ~state[2] & ~state[1] & ~state[0];

assign Wait_next = ~state[9] & ~state[8] & state[7] & ~state[6] & ~state[5] & ~state[4] & ~state[3] & ~state[2] & ~state[1] & ~state[0];

// Output logic
assign shift_ena = ~state[9] & ~state[8] & ~state[7] & ~state[6] & state[5] & ~state[4] & ~state[3] & ~state[2] & ~state[1] & ~state[0] |
                  ~state[9] & ~state[8] & ~state[7] & ~state[6] & ~state[5] & state[4] & ~state[3] & ~state[2] & ~state[1] & ~state[0] |
                  ~state[9] & ~state[8] & ~state[7] & ~state[6] & ~state[5] & ~state[4] & state[3] & ~state[2] & ~state[1] & ~state[0] |
                  ~state[9] & ~state[8] & ~state[7] & ~state[6] & ~state[5] & ~state[4] & ~state[3] & state[2] & ~state[1] & ~state[0];

assign counting = ~state[9] & state[8] & ~state[7] & ~state[6] & ~state[5] & ~state[4] & ~state[3] & ~state[2] & ~state[1] & ~state[0];

assign done = ~state[9] & ~state[8] & state[7] & ~state[6] & ~state[5] & ~state[4] & ~state[3] & ~state[2] & ~state[1] & ~state[0];

endmodule