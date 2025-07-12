module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot encoded state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Named state bit positions (one-hot encoding)
localparam S     = 0;
localparam S1    = 1;
localparam S11   = 2;
localparam S110  = 3;
localparam B0    = 4;
localparam B1    = 5;
localparam B2    = 6;
localparam B3    = 7;
localparam COUNT = 8;
localparam WAIT  = 9;

// Next state logic - optimized and documented
// S transitions (4 possible sources)
wire s_stay      = state[S] & ~d;
wire s1_to_s     = state[S1] & ~d;
wire s110_to_s   = state[S110] & ~d;
wire wait_to_s   = state[WAIT] & ack;
assign S_next    = s_stay | s1_to_s | s110_to_s | wait_to_s;

// S1 transitions (only from S)
assign S1_next   = state[S] & d;

// B3 transitions (only from B2)
assign B3_next   = state[B2];

// Count transitions (from B3 or self-loop)
wire b3_to_count = state[B3];
wire count_loop  = state[COUNT] & ~done_counting;
assign Count_next = b3_to_count | count_loop;

// Wait transitions (from Count or self-loop)
wire count_to_wait = state[COUNT] & done_counting;
wire wait_loop     = state[WAIT] & ~ack;
assign Wait_next   = count_to_wait | wait_loop;

// Output logic - minimal and direct
assign done      = state[WAIT];
assign counting  = state[COUNT];
assign shift_ena = state[B0] | state[B1] | state[B2] | state[B3];  // B states

endmodule