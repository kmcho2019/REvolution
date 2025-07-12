module TopModule(
    input  wire       d,
    input  wire       done_counting,
    input  wire       ack,
    input  wire [9:0] state,      // one-hot encoding
    output wire       B3_next,
    output wire       S_next,
    output wire       S1_next,
    output wire       Count_next,
    output wire       Wait_next,
    output wire       done,
    output wire       counting,
    output wire       shift_ena
);

// State bit assignments (one-hot)
// bit0 = S, bit1 = S1, bit2 = S11, bit3 = S110, bit4 = B0,
// bit5 = B1, bit6 = B2, bit7 = B3, bit8 = Count, bit9 = Wait
wire S    = state[0];
wire S1   = state[1];
wire S11  = state[2];
wire S110 = state[3];
wire B0   = state[4];
wire B1   = state[5];
wire B2   = state[6];
wire B3   = state[7];
wire Count= state[8];
wire Wait = state[9];

// Next state logic directly from transitions

// Next S: from S(d=0), S1(d=0), S110(d=0), Wait(ack=1)
wire next_S_from_S      = S    & (~d);
wire next_S_from_S1     = S1   & (~d);
wire next_S_from_S110   = S110 & (~d);
wire next_S_from_Wait   = Wait & ack;
assign S_next = next_S_from_S | next_S_from_S1 | next_S_from_S110 | next_S_from_Wait;

// Next S1: from S(d=1)
assign S1_next = S & d;

// Next S11: from S1(d=1), S11(d=1)
wire next_S11_from_S1  = S1  & d;
wire next_S11_from_S11 = S11 & d;

// Next S110: from S11(d=0)
wire next_S110_from_S11 = S11 & (~d);

// Next B0: from S110(d=1)
wire next_B0_from_S110 = S110 & d;

// Next B1: from B0
wire next_B1_from_B0 = B0;

// Next B2: from B1
wire next_B2_from_B1 = B1;

// Next B3: from B2
assign B3_next = B2;

// Next Count: from B3, and stay if done_counting=0
wire next_Count_from_B3 = B3;
wire next_Count_stay    = Count & (~done_counting);
assign Count_next = next_Count_from_B3 | next_Count_stay;

// Next Wait: from Count(done_counting=1), stay if ack=0
wire next_Wait_from_Count_done = Count & done_counting;
wire next_Wait_stay            = Wait & (~ack);
assign Wait_next = next_Wait_from_Count_done | next_Wait_stay;

// Moore outputs from current state
assign shift_ena = B0 | B1 | B2 | B3;
assign counting  = Count;
assign done      = Wait;

endmodule