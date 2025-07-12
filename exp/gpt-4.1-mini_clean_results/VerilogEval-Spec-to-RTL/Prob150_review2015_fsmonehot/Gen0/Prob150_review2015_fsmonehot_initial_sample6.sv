module TopModule (
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,          // one-hot current state
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// State bit definitions for readability
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

// Extract each state bit for readability
wire S    = state[S_BIT];
wire S1   = state[S1_BIT];
wire S11  = state[S11_BIT];
wire S110 = state[S110_BIT];
wire B0   = state[B0_BIT];
wire B1   = state[B1_BIT];
wire B2   = state[B2_BIT];
wire B3   = state[B3_BIT];
wire Count = state[COUNT_BIT];
wire Wait  = state[WAIT_BIT];

// Next state logic by inspection

// Next S:
// From S when d=0
// From S1 when d=0
// From S110 when d=0
// From Wait when ack=1
assign S_next = 
    (S   & ~d) | 
    (S1  & ~d) | 
    (S110 & ~d) | 
    (Wait & ack);

// Next S1:
// From S when d=1
assign S1_next = (S & d);

// Next S11:
// From S1 when d=1
// From S11 when d=1
assign wire_s11_next;
assign wire_s11_next = (S1 & d) | (S11 & d);
wire S11_next = wire_s11_next; // internal use only

// Next S110:
// From S11 when d=0
assign wire_s110_next = (S11 & ~d);
wire S110_next = wire_s110_next; // internal use only

// Next B0:
// From S110 when d=1
assign wire_b0_next = (S110 & d);
wire B0_next_internal = wire_b0_next; // internal use only

// Next B1:
// From B0 always
assign wire_b1_next = B0;
wire B1_next_internal = wire_b1_next;

// Next B2:
// From B1 always
assign wire_b2_next = B1;
wire B2_next_internal = wire_b2_next;

// Next B3:
// From B2 always
assign B3_next = B2;

// Next Count:
// From B3 always
// From Count when done_counting=0
assign Count_next = (B3) | (Count & ~done_counting);

// Next Wait:
// From Count when done_counting=1
// From Wait when ack=0
assign Wait_next = (Count & done_counting) | (Wait & ~ack);

// Output signals:

// done = 1 in Wait
assign done = Wait;

// counting = 1 in Count
assign counting = Count;

// shift_ena = 1 in B0, B1, B2, B3
assign shift_ena = B0 | B1 | B2 | B3;

endmodule