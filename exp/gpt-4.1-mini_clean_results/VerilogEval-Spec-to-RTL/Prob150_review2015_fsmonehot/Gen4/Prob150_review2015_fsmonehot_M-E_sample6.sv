module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,        // one-hot encoded
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // Decode current state bits
  wire S    = state[0];
  wire S1   = state[1];
  wire S11  = state[2];
  wire S110 = state[3];
  wire B0   = state[4];
  wire B1   = state[5];
  wire B2   = state[6];
  wire B3   = state[7];
  wire Count = state[8];
  wire Wait = state[9];

  // Next-state bits (one-hot, 10 bits)
  wire [9:0] next_state;

  // Next-state logic for each bit:

  // next S:
  // S(d=0), S1(d=0), S110(d=0), Wait(ack=1)
  wire S_next_bit = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // next S1:
  // S(d=1)
  wire S1_next_bit = S & d;

  // next S11:
  // S1(d=1), S11(d=1)
  wire S11_next_bit = (S1 & d) | (S11 & d);

  // next S110:
  // S11(d=0)
  wire S110_next_bit = S11 & ~d;

  // next B0:
  // S110(d=1)
  wire B0_next_bit = S110 & d;

  // next B1:
  // B0 (always)
  wire B1_next_bit = B0;

  // next B2:
  // B1 (always)
  wire B2_next_bit = B1;

  // next B3:
  // B2 (always)
  wire B3_next_bit = B2;

  // next Count:
  // B3 (always), Count (done_counting=0)
  wire Count_next_bit = B3 | (Count & ~done_counting);

  // next Wait:
  // Count(done_counting=1), Wait(ack=0)
  wire Wait_next_bit = (Count & done_counting) | (Wait & ~ack);

  assign next_state = {Wait_next_bit, Count_next_bit, B3_next_bit, B2_next_bit, B1_next_bit,
                       B0_next_bit, S110_next_bit, S11_next_bit, S1_next_bit, S_next_bit};

  // Now assign requested next-state outputs:
  assign B3_next  = next_state[7];  // B3
  assign S_next   = next_state[0];  // S
  assign S1_next  = next_state[1];  // S1
  assign Count_next = next_state[8]; // Count
  assign Wait_next  = next_state[9]; // Wait

  // Moore output logic depends only on current state:
  assign shift_ena = B0 | B1 | B2 | B3;
  assign done = Wait;
  assign counting = Count;

endmodule