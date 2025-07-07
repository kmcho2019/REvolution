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
  localparam S    = 10'b0000000001;
  localparam S1   = 10'b0000000010;
  localparam S11  = 10'b0000000100;
  localparam S110 = 10'b0000001000;
  localparam B0   = 10'b0000010000;
  localparam B1   = 10'b0000100000;
  localparam B2   = 10'b0001000000;
  localparam B3   = 10'b0010000000;
  localparam Count= 10'b0100000000;
  localparam Wait = 10'b1000000000;

  // Next state logic signals

  // S_next:
  // From S on d=0 -> S
  // From S1 on d=0 -> S
  // From S110 on d=0 -> S
  // From Wait on ack=1 -> S
  assign S_next = 
       (state[0] & ~d)        // S and d=0
    |  (state[1] & ~d)        // S1 and d=0
    |  (state[3] & ~d)        // S110 and d=0
    |  (state[9] & ack);      // Wait and ack=1

  // S1_next:
  // From S on d=1 -> S1
  assign S1_next = (state[0] & d);

  // B3_next:
  // From B2 always -> B3
  assign B3_next = state[6];

  // Count_next:
  // From B3 always -> Count
  assign Count_next = state[7];

  // Wait_next:
  // From Count on done_counting=1 -> Wait
  assign Wait_next = (state[8] & done_counting);

  // Outputs (Moore outputs depend only on current state)
  assign shift_ena = state[4] | state[5] | state[6] | state[7]; // B0,B1,B2,B3
  assign counting  = state[8]; // Count
  assign done      = state[9]; // Wait

endmodule