module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,         // one-hot state encoding as described
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// State bit positions for clarity
localparam S_BIT    = 0;
localparam S1_BIT   = 1;
localparam S11_BIT  = 2;
localparam S110_BIT = 3;
localparam B0_BIT   = 4;
localparam B1_BIT   = 5;
localparam B2_BIT   = 6;
localparam B3_BIT   = 7;
localparam COUNT_BIT= 8;
localparam WAIT_BIT = 9;

// Extract state bits
wire S     = state[S_BIT];
wire S1    = state[S1_BIT];
wire S11   = state[S11_BIT];
wire S110  = state[S110_BIT];
wire B0    = state[B0_BIT];
wire B1    = state[B1_BIT];
wire B2    = state[B2_BIT];
wire B3    = state[B3_BIT];
wire Count = state[COUNT_BIT];
wire Wait  = state[WAIT_BIT];

// Next state logic:
// Initialize all next states to zero, then assign logic

// S_next:
// From S: d=0 -> S
// From S1: d=0 -> S
// From S11: d=0 -> S110 (no, S110, not S)
// From S110: d=0 -> S
// From Wait: ack=1 -> S
wire S_next_from_S     = S  & (~d);
wire S_next_from_S1    = S1 & (~d);
wire S_next_from_S110  = S110 & (~d);
wire S_next_from_Wait  = Wait & ack;

assign S_next = S_next_from_S | S_next_from_S1 | S_next_from_S110 | S_next_from_Wait;

// S1_next:
// From S: d=1 -> S1
assign S1_next = S & d;

// S11_next:
// From S1: d=1 -> S11
// From S11: d=1 -> S11
assign wire S11_next = (S1 & d) | (S11 & d);

// B0_next:
// From S110: d=1 -> B0
assign wire B0_next = S110 & d;

// B1_next:
// From B0: always -> B1
assign wire B1_next = B0;

// B2_next:
// From B1: always -> B2
assign wire B2_next = B1;

// B3_next:
// From B2: always -> B3
assign wire B3_next = B2;

// Count_next:
// From B3: always -> Count
// From Count: done_counting=0 -> Count
assign Count_next = B3 | (Count & (~done_counting));

// Wait_next:
// From Count: done_counting=1 -> Wait
// From Wait: ack=0 -> Wait
assign Wait_next = (Count & done_counting) | (Wait & (~ack));

// Redefine B3_next output as required:
assign B3_next = B3_next;

// Outputs:

// done = 1 in Wait state
assign done = Wait;

// counting = 1 in Count state
assign counting = Count;

// shift_ena = 1 in B0, B1, B2, B3 states
assign shift_ena = B0 | B1 | B2 | B3;

endmodule