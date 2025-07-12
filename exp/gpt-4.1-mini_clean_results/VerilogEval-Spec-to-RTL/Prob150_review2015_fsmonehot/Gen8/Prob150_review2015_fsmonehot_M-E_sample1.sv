module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,        // one-hot encoded current state
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

  // Decode one-hot current state bits
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

  // Next state logic derived directly from state transition table

  // Next state S:
  // - from S on d=0
  // - from S1 on d=0
  // - from S110 on d=0
  // - from Wait on ack=1
  assign S_next = (S & (~d)) | (S1 & (~d)) | (S110 & (~d)) | (Wait & ack);

  // Next state S1:
  // - from S on d=1
  assign S1_next = S & d;

  // Next state B3:
  // - from B2 (always)
  assign B3_next = B2;

  // Next state Count:
  // - from B3 (always)
  // - remain in Count while done_counting=0
  assign Count_next = B3 | (Count & (~done_counting));

  // Next state Wait:
  // - from Count when done_counting=1
  // - remain in Wait while ack=0
  assign Wait_next = (Count & done_counting) | (Wait & (~ack));

  // Moore outputs driven directly from current states
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule