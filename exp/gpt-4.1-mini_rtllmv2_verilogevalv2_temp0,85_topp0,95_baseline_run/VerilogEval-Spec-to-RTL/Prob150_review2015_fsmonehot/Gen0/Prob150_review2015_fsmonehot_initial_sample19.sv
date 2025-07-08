module TopModule (
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,       // one-hot encoded current state
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

// State bit indices for clarity
localparam S_BIT    = 0;
localparam S1_BIT   = 1;
localparam S11_BIT  = 2;
localparam S110_BIT = 3;
localparam B0_BIT   = 4;
localparam B1_BIT   = 5;
localparam B2_BIT   = 6;
localparam B3_BIT   = 7;
localparam Count_BIT= 8;
localparam Wait_BIT = 9;

// Current state bits
wire S    = state[S_BIT];
wire S1   = state[S1_BIT];
wire S11  = state[S11_BIT];
wire S110 = state[S110_BIT];
wire B0   = state[B0_BIT];
wire B1   = state[B1_BIT];
wire B2   = state[B2_BIT];
wire B3   = state[B3_BIT];
wire Count= state[Count_BIT];
wire Wait = state[Wait_BIT];

// Next state bits logic (one-hot)
wire next_S;
wire next_S1;
wire next_S11;
wire next_S110;
wire next_B0;
wire next_B1;
wire next_B2;
wire next_B3;
wire next_Count;
wire next_Wait;

// Next state logic from S
assign next_S1  = S & d;
assign next_S   = (S & ~d)
                | (S1 & ~d)
                | (S110 & ~d)
                | (Wait & ack);

// Next state logic from S1
assign next_S11 = S1 & d;

// Next state logic from S11
assign next_S110= S11 & (~d);
assign next_S11 = next_S11 | (S11 & d); // S11 loops to itself if d=1

// Next state logic from S110
assign next_B0  = S110 & d;

// Next state logic from B0->B1->B2->B3->Count (always go to next cycle)
assign next_B1  = B0;
assign next_B2  = B1;
assign next_B3  = B2;
assign next_Count= B3 | (Count & ~done_counting);

// Next state logic from Count
assign next_Wait= Count & done_counting;

// Next state logic from Wait
assign next_Wait = next_Wait | (Wait & ~ack);

// Outputs indicating next state asserted
assign B3_next   = next_B3;
assign S_next    = next_S;
assign S1_next   = next_S1;
assign Count_next= next_Count;
assign Wait_next = next_Wait;

// Output logic (Moore outputs)
// shift_ena = 1 for states B0,B1,B2,B3
assign shift_ena = B0 | B1 | B2 | B3;
// counting = 1 for Count
assign counting  = Count;
// done = 1 for Wait
assign done      = Wait;

endmodule