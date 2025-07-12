module TopModule(
    input  wire       d,
    input  wire       done_counting,
    input  wire       ack,
    input  wire [9:0] state,    // one-hot encoding
    output wire       B3_next,
    output wire       S_next,
    output wire       S1_next,
    output wire       Count_next,
    output wire       Wait_next,
    output wire       done,
    output wire       counting,
    output wire       shift_ena
);

// State bit indices for clarity
localparam S_bit     = 0;
localparam S1_bit    = 1;
localparam S11_bit   = 2;
localparam S110_bit  = 3;
localparam B0_bit    = 4;
localparam B1_bit    = 5;
localparam B2_bit    = 6;
localparam B3_bit    = 7;
localparam Count_bit = 8;
localparam Wait_bit  = 9;

// Output logic: Moore outputs depend on current state only
assign done      = state[Wait_bit];
assign counting  = state[Count_bit];
assign shift_ena = |(state[B0_bit +:4]); // OR of B0, B1, B2, B3 states

// Next-state logic for outputs requested (one-hot next state bits)

// S_next:
// - From S: d=0 -> S
// - From S1: d=0 -> S
// - From S110: d=0 -> S
// - From Wait: ack=1 -> S
assign S_next = ((state[S_bit] | state[S1_bit] | state[S110_bit]) & ~d) | (state[Wait_bit] & ack);

// S1_next:
// - From S: d=1 -> S1
assign S1_next = state[S_bit] & d;

// B3_next:
// - From B2: always -> B3
assign B3_next = state[B2_bit];

// Count_next:
// - From B3: always -> Count
// - From Count: done_counting=0 -> Count
assign Count_next = state[B3_bit] | (state[Count_bit] & ~done_counting);

// Wait_next:
// - From Count: done_counting=1 -> Wait
// - From Wait: ack=0 -> Wait
assign Wait_next = (state[Count_bit] & done_counting) | (state[Wait_bit] & ~ack);

endmodule