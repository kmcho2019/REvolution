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

  // Decode current state bits
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

  // Next-state logic optimized with factoring common terms

  // Next state S:
  // From S, S1, S110 on d=0 and from Wait on ack=1
  assign S_next = (~d & (S | S1 | S110)) | (Wait & ack);

  // Next state S1:
  // From S on d=1
  assign S1_next = S & d;

  // Next state B3:
  // From B2 (always)
  assign B3_next = B2;

  // Next state Count:
  // From B3 (always) or Count stays if done_counting=0
  assign Count_next = B3 | (Count & ~done_counting);

  // Next state Wait:
  // From Count if done_counting=1 or Wait stays if ack=0
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Output logic (Moore outputs)
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule