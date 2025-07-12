module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,   // one-hot encoding of current state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // Decode current one-hot state bits for readability
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

  // Declare next state one-hot bits
  wire [9:0] next_state;

  // Next-state logic fully enumerated for all states

  // State S (0000000001)
  // S  --d=0--> S
  // S  --d=1--> S1
  assign next_state[0] = S  & ~d       // S_next for S state
                      | S1 & ~d       // S_next for S1 state d=0
                      | S110 & ~d     // S_next for S110 state d=0
                      | Wait & ack;   // S_next for Wait state ack=1

  assign next_state[1] = S  & d;         // S1_next from S when d=1

  assign next_state[2] = S1  & d          // S11 from S1 d=1
                       | S11 & d          // S11 self-loop on d=1
                       ;

  assign next_state[3] = S11 & ~d;       // S110 from S11 d=0

  assign next_state[4] = S110 & d;       // B0 from S110 d=1

  // B states cycle through B0->B1->B2->B3 always
  assign next_state[5] = B0;              // B1 next from B0
  assign next_state[6] = B1;              // B2 next from B1
  assign next_state[7] = B2;              // B3 next from B2

  // Count and Wait states with done_counting and ack inputs
  assign next_state[8] = B3                        // Count next from B3
                      | (Count & ~done_counting); // stay in Count if not done counting

  assign next_state[9] = (Count & done_counting)  // Wait from Count done
                      | (Wait & ~ack);            // Stay in Wait if ack=0

  // Assign requested next-state outputs by detecting corresponding bits in next_state
  assign S_next     = next_state[0];
  assign S1_next    = next_state[1];
  assign B3_next    = next_state[7];
  assign Count_next = next_state[8];
  assign Wait_next  = next_state[9];

  // Output logic (Moore)
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule