module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,       // one-hot encoding: S=bit0 ... Wait=bit9
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // Decode current one-hot states
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

  // Next-state signals derived independently for clarity
  assign S_next     = (S & ~d)        // S->S if d=0
                    | (S1 & ~d)       // S1->S if d=0
                    | (S110 & ~d)     // S110->S if d=0
                    | (Wait & ack);   // Wait->S if ack=1

  assign S1_next    = S & d;           // S->S1 if d=1

  assign B3_next    = B2;              // B2->B3 unconditionally

  assign Count_next = B3                 // B3->Count
                    | (Count & ~done_counting);  // Count->Count if not done

  assign Wait_next  = (Count & done_counting)   // Count->Wait if done
                    | (Wait & ~ack);            // Wait->Wait if no ack

  // Moore outputs are asserted according to current state (one-hot)
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule