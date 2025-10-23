module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,       // one-hot encoding of current state
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

  // Current state one-hot bits (optional for clarity, but could use directly)
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

  // Define next_state as a 10-bit vector corresponding to one-hot encoding of next states
  wire [9:0] next_state;

  // next_state[0] = S_next
  assign next_state[0] = (~d & (S | S1 | S110)) | (Wait & ack);

  // next_state[1] = S1_next
  assign next_state[1] = S & d;

  // next_state[2] = S11 (not requested as next output, so 0)
  assign next_state[2] = 1'b0;

  // next_state[3] = S110 (not requested as next output, so 0)
  assign next_state[3] = 1'b0;

  // next_state[4] = B0 (not requested as next output, so 0)
  assign next_state[4] = 1'b0;

  // next_state[5] = B1 (not requested as next output, so 0)
  assign next_state[5] = 1'b0;

  // next_state[6] = B2 (not requested as next output, so 0)
  assign next_state[6] = 1'b0;

  // next_state[7] = B3_next
  assign next_state[7] = B2;

  // next_state[8] = Count_next
  assign next_state[8] = B3 | (Count & ~done_counting);

  // next_state[9] = Wait_next
  assign next_state[9] = (Count & done_counting) | (Wait & ~ack);

  // Assign outputs from next_state bits
  assign S_next     = next_state[0];
  assign S1_next    = next_state[1];
  assign B3_next    = next_state[7];
  assign Count_next = next_state[8];
  assign Wait_next  = next_state[9];

  // Output logic - Moore outputs based on current state
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule