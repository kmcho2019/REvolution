module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input [9:0]  state,
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

// State bits for readability
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

// Next state logic

// S_next:
// from S on d=0
// from S1 on d=0
// from S110 on d=0
// from Wait on ack=1
assign S_next = (S   & ~d) |
                (S1  & ~d) |
                (S110 & ~d) |
                (Wait & ack);

// S1_next:
// from S on d=1
assign S1_next = S & d;

// S11_next:
// from S1 on d=1
// from S11 on d=1
wire S11_next = (S1 & d) | (S11 & d); // Not requested to output, but for completeness

// S110_next:
// from S11 on d=0
wire S110_next = S11 & ~d; // Not requested to output

// B0_next:
// from S110 on d=1
wire B0_next = S110 & d; // Not requested to output

// B1_next:
// from B0 always
wire B1_next = B0; // Not requested to output

// B2_next:
// from B1 always
wire B2_next = B1; // Not requested to output

// B3_next:
// from B2 always
assign B3_next = B2;

// Count_next:
// from B3 always
// from Count when done_counting=0
assign Count_next = B3 | (Count & ~done_counting);

// Wait_next:
// from Count when done_counting=1
// from Wait when ack=0
assign Wait_next = (Count & done_counting) | (Wait & ~ack);

// Outputs (Moore):
assign shift_ena = B0 | B1 | B2 | B3;
assign counting  = Count;
assign done      = Wait;

endmodule