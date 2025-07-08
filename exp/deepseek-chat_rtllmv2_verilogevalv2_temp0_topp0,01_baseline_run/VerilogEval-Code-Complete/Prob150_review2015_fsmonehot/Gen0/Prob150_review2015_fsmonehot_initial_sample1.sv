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

  // Next state logic
  assign S_next = (state[0] & ~d) |       // S and d=0 -> S
                  (state[1] & ~d) |       // S1 and d=0 -> S
                  (state[3] & ~d) |       // S110 and d=0 -> S
                  (state[9] & ack);       // Wait and ack=1 -> S

  assign S1_next = (state[0] & d) |       // S and d=1 -> S1
                   (state[1] & d);        // S1 and d=1 -> S11 (but S11_next not requested)

  assign Count_next = state[7] |          // B3 always goes to Count
                      (state[8] & ~done_counting); // Count stays if not done_counting

  assign Wait_next = (state[8] & done_counting) |  // Count and done_counting=1 -> Wait
                     (state[9] & ~ack);   // Wait stays if ack=0

  assign B3_next = state[6];              // B2 always goes to B3

  // Output logic
  assign shift_ena = |state[4:7];         // B0-B3 states (bits 4-7)
  assign counting = state[8];             // Count state (bit 8)
  assign done = state[9];                 // Wait state (bit 9)

endmodule