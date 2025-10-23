module TopModule(
    input  wire       d,
    input  wire       done_counting,
    input  wire       ack,
    input  wire [9:0] state,         // one-hot: S=bit0 ... Wait=bit9
    output wire       B3_next,
    output wire       S_next,
    output wire       S1_next,
    output wire       Count_next,
    output wire       Wait_next,
    output wire       done,
    output wire       counting,
    output wire       shift_ena
);

// State indices
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

// Current states
wire S    = state[S_BIT];
wire S1   = state[S1_BIT];
wire S11  = state[S11_BIT];
wire S110 = state[S110_BIT];
wire B0   = state[B0_BIT];
wire B1   = state[B1_BIT];
wire B2   = state[B2_BIT];
wire B3   = state[B3_BIT];
wire COUNT= state[COUNT_BIT];
wire WAIT = state[WAIT_BIT];

// Next state logic based on transitions:

// From S: d=0->S; d=1->S1
wire next_S_from_S  = S & ~d;
wire next_S1_from_S = S & d;

// From S1: d=0->S; d=1->S11
wire next_S_from_S1  = S1 & ~d;
wire next_S11_from_S1= S1 & d;

// From S11: d=0->S110; d=1->S11
wire next_S110_from_S11 = S11 & ~d;
wire next_S11_from_S11  = S11 & d;

// From S110: d=0->S; d=1->B0
wire next_S_from_S110 = S110 & ~d;
wire next_B0_from_S110= S110 & d;

// From B0: always next B1
wire next_B1_from_B0 = B0;

// From B1: always next B2
wire next_B2_from_B1 = B1;

// From B2: always next B3
wire next_B3_from_B2 = B2;

// From B3: always next Count
wire next_COUNT_from_B3 = B3;

// From Count: done_counting=0 -> Count; done_counting=1 -> Wait
wire next_COUNT_from_COUNT = COUNT & ~done_counting;
wire next_WAIT_from_COUNT  = COUNT & done_counting;

// From Wait: ack=0 -> Wait; ack=1 -> S
wire next_WAIT_from_WAIT = WAIT & ~ack;
wire next_S_from_WAIT    = WAIT & ack;

// Aggregate next state signals (one-hot)
assign S_next   = next_S_from_S | next_S_from_S1 | next_S_from_S110 | next_S_from_WAIT;
assign S1_next  = next_S1_from_S;
assign S11_next = next_S11_from_S1 | next_S11_from_S11;
assign S110_next= next_S110_from_S11;
assign B0_next  = next_B0_from_S110;
assign B1_next  = next_B1_from_B0;
assign B2_next  = next_B2_from_B1;
assign B3_next  = next_B3_from_B2;
assign Count_next = next_COUNT_from_B3 | next_COUNT_from_COUNT;
assign Wait_next  = next_WAIT_from_COUNT | next_WAIT_from_WAIT;

// Output logic (Moore outputs)
assign shift_ena = B0 | B1 | B2 | B3;
assign counting  = COUNT;
assign done      = WAIT;

endmodule