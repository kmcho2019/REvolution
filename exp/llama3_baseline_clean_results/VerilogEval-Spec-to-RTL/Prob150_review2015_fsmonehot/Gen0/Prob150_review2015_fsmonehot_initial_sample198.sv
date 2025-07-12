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

// Define the current state
wire [9:0] curr_state;

assign curr_state = state;

// Next state logic
assign B3_next = (curr_state == 10'b0001000000) | (curr_state == 10'b0000100000) | (curr_state == 10'b0000010000) | (curr_state == 10'b0010000000);
assign S_next = (curr_state == 10'b0000000001) & ~d | (curr_state == 10'b0000000010) & ~d | (curr_state == 10'b0000001000) & ~d | (curr_state == 10'b1000000000) & ack;
assign S1_next = (curr_state == 10'b0000000001) & d;
assign Count_next = (curr_state == 10'b0100000000) | (curr_state == 10'b0010000000) & done_counting;
assign Wait_next = (curr_state == 10'b0100000000) & ~done_counting | (curr_state == 10'b1000000000) & ~ack;

// Output logic
assign shift_ena = (curr_state == 10'b0000010000) | (curr_state == 10'b0000100000) | (curr_state == 10'b0001000000) | (curr_state == 10'b0010000000);
assign counting = (curr_state == 10'b0100000000);
assign done = (curr_state == 10'b1000000000);

endmodule