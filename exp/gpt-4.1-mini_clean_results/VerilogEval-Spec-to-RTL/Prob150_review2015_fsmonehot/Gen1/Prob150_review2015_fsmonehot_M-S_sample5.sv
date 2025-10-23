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

// State bit indices
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

// Next state logic for specified next-state outputs:

// Next state S:
// from S(0) d=0
// from S1(1) d=0
// from S110(3) d=0
// from Wait(9) ack=1
assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

// Next state S1:
// from S(0) d=1
assign S1_next = (S & d);

// Next state B3:
// from B2(6) always
assign B3_next = B2;

// Next state Count:
// from B3(7) always
// from Count(8) done_counting=0
assign Count_next = (B3) | (Count & ~done_counting);

// Next state Wait:
// from Count(8) done_counting=1
// from Wait(9) ack=0
assign Wait_next = (Count & done_counting) | (Wait & ~ack);

// Outputs
assign done      = Wait;
assign counting  = Count;
assign shift_ena = B0 | B1 | B2 | B3;

endmodule