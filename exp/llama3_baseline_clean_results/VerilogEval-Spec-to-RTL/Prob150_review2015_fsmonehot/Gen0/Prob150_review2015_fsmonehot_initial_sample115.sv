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

// State transition logic
assign B3_next = (state[9:8] == 2'b01) & ~d;  // B2 to B3
assign S_next = (state[9:0] == 10'b0000000001) |  // S to S
                (state[9:0] == 10'b0000000010) & ~d |  // S1 to S
                (state[9:0] == 10'b0000000100) & ~d |  // S11 to S110
                (state[9:0] == 10'b0000001000) & ~d |  // S110 to S
                (state[9:0] == 10'b1000000000) & ack;  // Wait to S
assign S1_next = (state[9:0] == 10'b0000000001) & d;  // S to S1
assign Count_next = (state[9:0] == 10'b0000000001_2) & done_counting;  // B3 to Count
assign Wait_next = (state[9:0] == 10'b0000000001_2) & ~done_counting;  // B3 to Wait

// Output logic
assign shift_ena = (state[9:0] == 10'b0000010000) |  // B0
                    (state[9:0] == 10'b0000100000) |  // B1
                    (state[9:0] == 10'b0001000000) |  // B2
                    (state[9:0] == 10'b0010000000);   // B3
assign counting = (state[9:0] == 10'b0100000000);  // Count
assign done = (state[9:0] == 10'b1000000000);      // Wait

endmodule