module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,       // one-hot encoded current state
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

  // Current state bits
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

  // Next state combinational logic directly assigned
  assign S_next = (S    & ~d) 
                | (S1   & ~d) 
                | (S110 & ~d) 
                | (Wait & ack);

  assign S1_next = S & d;

  // S11 next state is not requested as output, but for completeness:
  // from S1 and d=1 goes to S11, S11 stays with d=1, and goes to S110 with d=0
  // Not needed for output signals per spec.

  assign B3_next = B2;

  assign Count_next = (B3) 
                   | (Count & ~done_counting);

  assign Wait_next = (Count & done_counting)
                  | (Wait & ~ack);

  // Moore outputs assigned directly from current state signals
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule