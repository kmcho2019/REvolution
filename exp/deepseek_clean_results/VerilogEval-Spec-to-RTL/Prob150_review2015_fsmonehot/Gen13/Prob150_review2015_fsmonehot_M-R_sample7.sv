module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot encoding: S=bit0, S1=bit1, S11=bit2, S110=bit3,
                        // B0=bit4, B1=bit5, B2=bit6, B3=bit7, Count=bit8, Wait=bit9
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// State transition conditions
wire s_to_s      = state[0] & ~d;
wire s1_to_s     = state[1] & ~d;
wire s110_to_s   = state[3] & ~d;
wire wait_to_s   = state[9] & ack;

wire s_to_s1     = state[0] & d;

wire b2_to_b3    = state[6];

wire b3_to_count = state[7];
wire count_hold  = state[8] & ~done_counting;

wire count_to_wait = state[8] & done_counting;
wire wait_hold     = state[9] & ~ack;

// Next state logic
assign S_next     = s_to_s | s1_to_s | s110_to_s | wait_to_s;
assign S1_next    = s_to_s1;
assign B3_next    = b2_to_b3;
assign Count_next = b3_to_count | count_hold;
assign Wait_next  = count_to_wait | wait_hold;

// Output logic
wire in_b0_state = state[4];
wire in_b1_state = state[5];
wire in_b2_state = state[6];
wire in_b3_state = state[7];

assign shift_ena = in_b0_state | in_b1_state | in_b2_state | in_b3_state;
assign counting  = state[8];  // Count state
assign done      = state[9];  // Wait state

endmodule