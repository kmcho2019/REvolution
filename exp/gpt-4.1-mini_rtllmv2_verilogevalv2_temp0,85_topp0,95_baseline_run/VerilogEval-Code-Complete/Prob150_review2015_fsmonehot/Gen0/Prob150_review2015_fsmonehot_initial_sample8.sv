module TopModule (
  input d,
  input done_counting,
  input ack,
  input [9:0] state, // 10-bit one-hot current state
  output B3_next,
  output S_next,
  output S1_next,
  output Count_next,
  output Wait_next,
  output done,
  output counting,
  output shift_ena
);

// State encoding for clarity
//  S=10'b0000000001      state[0]
//  S1=10'b0000000010     state[1]
//  S11=10'b0000000100    state[2]
//  S110=10'b0000001000   state[3]
//  B0=10'b0000010000     state[4]
//  B1=10'b0000100000     state[5]
//  B2=10'b0001000000     state[6]
//  B3=10'b0010000000     state[7]
//  Count=10'b0100000000  state[8]
//  Wait=10'b1000000000   state[9]

wire S  = state[0];
wire S1 = state[1];
wire S11 = state[2];
wire S110 = state[3];
wire B0 = state[4];
wire B1 = state[5];
wire B2 = state[6];
wire B3 = state[7];
wire Count = state[8];
wire Wait = state[9];

// Next-state signals:

// B3_next: next state is B3
// From B2 (always go to B3)
assign B3_next = B2;

// S_next: next state is S
// from S with d=0
// from S1 with d=0
// from S110 with d=0
// from Wait with ack=1
assign S_next = (S & (d == 1'b0))
              | (S1 & (d == 1'b0))
              | (S110 & (d == 1'b0))
              | (Wait & (ack == 1'b1));

// S1_next: next state is S1
// from S with d=1
assign S1_next = S & (d == 1'b1);

// Count_next: next state is Count
// from B3 (always go to Count)
assign Count_next = B3;

// Wait_next: next state is Wait
// from Count when done_counting=1
assign Wait_next = Count & done_counting;

// Outputs (Moore machine):

// done = 1 only in Wait state
assign done = Wait;

// counting = 1 only in Count state
assign counting = Count;

// shift_ena = 1 in states B0, B1, B2, B3
assign shift_ena = B0 | B1 | B2 | B3;

endmodule