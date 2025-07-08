module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// State bit indices for clarity
localparam S    = 0;
localparam S1   = 1;
localparam S11  = 2;
localparam S110 = 3;
localparam B0   = 4;
localparam B1   = 5;
localparam B2   = 6;
localparam B3   = 7;
localparam COUNT= 8;
localparam WAIT = 9;

// Current states
wire s    = state[S];
wire s1   = state[S1];
wire s11  = state[S11];
wire s110 = state[S110];
wire b0   = state[B0];
wire b1   = state[B1];
wire b2   = state[B2];
wire b3   = state[B3];
wire count= state[COUNT];
wire wait = state[WAIT];

// Next state logic for each state:

// Next S:
// From S: d=0 -> S
// From S1: d=0 -> S
// From S110: d=0 -> S
// From Wait: ack=1 -> S
wire S_next_from_S     = s    & (~d);
wire S_next_from_S1    = s1   & (~d);
wire S_next_from_S110  = s110 & (~d);
wire S_next_from_Wait  = wait & ack;
assign S_next = S_next_from_S | S_next_from_S1 | S_next_from_S110 | S_next_from_Wait;

// Next S1:
// From S: d=1 -> S1
assign S1_next = s & d;

// Next S11:
// From S1: d=1 -> S11
assign wire_s11_next_from_s1 = s1 & d;

// Next S11 (self loop):
// From S11: d=1 -> S11
wire s11_self = s11 & d;

// Next S110:
// From S11: d=0 -> S110
wire s110_next_from_s11 = s11 & (~d);

// Next B0:
// From S110: d=1 -> B0
wire b0_next_from_s110 = s110 & d;

// B0 always to B1
wire b1_next_from_b0 = b0;

// B1 always to B2
wire b2_next_from_b1 = b1;

// B2 always to B3
wire b3_next_from_b2 = b2;

// B3 always to Count
wire count_next_from_b3 = b3;

// Count:
// done_counting=0 -> Count
// done_counting=1 -> Wait
wire count_stay = count & (~done_counting);
wire wait_next_from_count = count & done_counting;

// Wait:
// ack=0 -> Wait
// ack=1 -> S (already handled in S_next)
wire wait_stay = wait & (~ack);

// Combine S11 next states: next S11 is from s1 & d OR s11 & d
wire S11_next = wire_s11_next_from_s1 | s11_self;

// Next S110 is from S11 with d=0
wire S110_next = s110_next_from_s11;

// Next B0:
wire B0_next = b0_next_from_s110;

// Next B1:
wire B1_next = b1_next_from_b0;

// Next B2:
wire B2_next = b2_next_from_b1;

// Next B3:
assign B3_next = b3_next_from_b2;

// Next Count:
assign Count_next = count_stay | count_next_from_b3;

// Next Wait:
assign Wait_next = wait_stay | wait_next_from_count;

// Outputs (Moore):

// shift_ena = 1 in B0, B1, B2, B3 states
assign shift_ena = b0 | b1 | b2 | b3;

// counting = 1 in Count state
assign counting = count;

// done = 1 in Wait state
assign done = wait;

endmodule