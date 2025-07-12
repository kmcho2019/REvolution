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

// Common current state signals for next-state logic
wire in_S_or_S1_or_S110 = state[S_bit] | state[S1_bit] | state[S110_bit];
wire in_B_states        = state[B0_bit] | state[B1_bit] | state[B2_bit] | state[B3_bit];

// Output logic (Moore outputs depend only on current state)
assign done      = state[Wait_bit];
assign counting  = state[Count_bit];
assign shift_ena = in_B_states;  // active in B0, B1, B2, B3

// Next-state logic outputs

// S_next:
// From S, S1, S110 if d=0; from Wait if ack=1
assign S_next = (in_S_or_S1_or_S110 & ~d) | (state[Wait_bit] & ack);

// S1_next:
// From S if d=1
assign S1_next = state[S_bit] & d;

// B3_next:
// From B2 always
assign B3_next = state[B2_bit];

// Count_next:
// From B3 always; from Count if done_counting=0
assign Count_next = state[B3_bit] | (state[Count_bit] & ~done_counting);

// Wait_next:
// From Count if done_counting=1; from Wait if ack=0
assign Wait_next = (state[Count_bit] & done_counting) | (state[Wait_bit] & ~ack);

endmodule