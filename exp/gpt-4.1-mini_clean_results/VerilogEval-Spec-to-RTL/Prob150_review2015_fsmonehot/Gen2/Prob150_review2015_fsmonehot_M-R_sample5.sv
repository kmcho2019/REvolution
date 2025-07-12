module TopModule (
  input        d,
  input        done_counting,
  input        ack,
  input  [9:0] state,
  output       B3_next,
  output       S_next,
  output       S1_next,
  output       Count_next,
  output       Wait_next,
  output       done,
  output       counting,
  output       shift_ena
);

  // Extract one-hot current state bits
  wire S     = state[0];
  wire S1    = state[1];
  wire S11   = state[2];
  wire S110  = state[3];
  wire B0    = state[4];
  wire B1    = state[5];
  wire B2    = state[6];
  wire B3    = state[7];
  wire Count = state[8];
  wire Wait  = state[9];

  // Declare next state vector
  wire [9:0] next_state;

  // Next-state logic for each state (one-hot encoding)

  // next_state[0] = S_next
  // From S: d=0 => S
  // From S1: d=0 => S
  // From S110: d=0 => S
  // From Wait: ack=1 => S
  assign next_state[0] = (S    & ~d) 
                       | (S1   & ~d) 
                       | (S110 & ~d)
                       | (Wait  & ack);

  // next_state[1] = S1_next
  // From S: d=1 => S1
  assign next_state[1] = S & d;

  // next_state[2] = S11_next
  // From S1: d=1 => S11
  // From S11: d=1 => S11
  assign next_state[2] = (S1 & d) | (S11 & d);

  // next_state[3] = S110_next
  // From S11: d=0 => S110
  assign next_state[3] = S11 & ~d;

  // next_state[4] = B0_next
  // From S110: d=1 => B0
  assign next_state[4] = S110 & d;

  // next_state[5] = B1_next
  // From B0: always next => B1
  assign next_state[5] = B0;

  // next_state[6] = B2_next
  // From B1: always next => B2
  assign next_state[6] = B1;

  // next_state[7] = B3_next
  // From B2: always next => B3
  assign next_state[7] = B2;

  // next_state[8] = Count_next
  // From B3: always next => Count
  // From Count: done_counting=0 => Count (self-loop)
  assign next_state[8] = B3 | (Count & ~done_counting);

  // next_state[9] = Wait_next
  // From Count: done_counting=1 => Wait
  // From Wait: ack=0 => Wait (self-loop)
  assign next_state[9] = (Count & done_counting) | (Wait & ~ack);

  // Assign outputs as requested from next_state bits or current state bits
  assign S_next      = next_state[0];
  assign S1_next     = next_state[1];
  assign B3_next     = next_state[7];
  assign Count_next  = next_state[8];
  assign Wait_next   = next_state[9];

  assign shift_ena   = B0 | B1 | B2 | B3;
  assign counting    = Count;
  assign done        = Wait;

endmodule