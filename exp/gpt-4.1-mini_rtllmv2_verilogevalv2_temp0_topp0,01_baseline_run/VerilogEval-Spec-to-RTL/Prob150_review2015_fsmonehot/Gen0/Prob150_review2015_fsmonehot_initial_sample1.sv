module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// State bits mapping (one-hot):
// bit 0: S
// bit 1: S1
// bit 2: S11
// bit 3: S110
// bit 4: B0
// bit 5: B1
// bit 6: B2
// bit 7: B3
// bit 8: Count
// bit 9: Wait

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

// Next state logic:

// S_next:
// From S: d=0 -> S
// From S1: d=0 -> S
// From S11: d=0 -> S
// From S110: d=0 -> S
// From Wait: ack=1 -> S
assign S_next = (S & ~d) | (S1 & ~d) | (S11 & ~d) | (S110 & ~d) | (Wait & ack);

// S1_next:
// From S: d=1 -> S1
assign S1_next = S & d;

// S11_next:
// From S1: d=1 -> S11
// From S11: d=1 -> S11
assign S11_next = (S1 & d) | (S11 & d);

// S110_next:
// From S11: d=0 -> S110
assign wire_S110_next = S11 & ~d; // internal wire for completeness, not output

// B0_next:
// From S110: d=1 -> B0
assign wire_B0_next = S110 & d; // internal wire for completeness, not output

// B1_next:
// From B0: always -> B1
assign wire_B1_next = B0;

// B2_next:
// From B1: always -> B2
assign wire_B2_next = B1;

// B3_next:
// From B2: always -> B3
assign B3_next = B2;

// Count_next:
// From B3: always -> Count
assign Count_next = B3;

// Wait_next:
// From Count: done_counting=1 -> Wait
assign Wait_next = Count & done_counting;

// Outputs:

// done: asserted in Wait state
assign done = Wait;

// counting: asserted in Count state
assign counting = Count;

// shift_ena: asserted in B0, B1, B2, B3 states
assign shift_ena = B0 | B1 | B2 | B3;

endmodule