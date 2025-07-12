module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// State bit positions (one-hot encoding)
localparam S_BIT = 0;
localparam S1_BIT = 1;
localparam S11_BIT = 2;
localparam S110_BIT = 3;
localparam B0_BIT = 4;
localparam B1_BIT = 5;
localparam B2_BIT = 6;
localparam B3_BIT = 7;
localparam COUNT_BIT = 8;
localparam WAIT_BIT = 9;

// S transitions
wire s_to_s = state[S_BIT] & ~d;
wire s1_to_s = state[S1_BIT] & ~d;
wire s110_to_s = state[S110_BIT] & ~d;
wire wait_to_s = state[WAIT_BIT] & ack;

// S1 transitions
wire s_to_s1 = state[S_BIT] & d;

// B3 transitions
wire b2_to_b3 = state[B2_BIT];

// Count transitions
wire b3_to_count = state[B3_BIT];
wire count_to_count = state[COUNT_BIT] & ~done_counting;

// Wait transitions
wire count_to_wait = state[COUNT_BIT] & done_counting;
wire wait_to_wait = state[WAIT_BIT] & ~ack;

// Next state logic
assign S_next = s_to_s | s1_to_s | s110_to_s | wait_to_s;
assign S1_next = s_to_s1;
assign B3_next = b2_to_b3;
assign Count_next = b3_to_count | count_to_count;
assign Wait_next = count_to_wait | wait_to_wait;

// Output logic
assign shift_ena = state[B0_BIT] | state[B1_BIT] | state[B2_BIT] | state[B3_BIT];
assign counting = state[COUNT_BIT];
assign done = state[WAIT_BIT];

endmodule