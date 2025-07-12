module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,        // one-hot encoding of current state
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

  // State bit indices for one-hot encoding
  localparam S_bit     = 0;
  localparam S1_bit    = 1;
  localparam S11_bit   = 2;
  localparam S110_bit  = 3;
  localparam B0_bit    = 4;
  localparam B1_bit    = 5;
  localparam B2_bit    = 6;
  localparam B3_bit    = 7;
  localparam Count_bit = 8;
  localparam Wait_bit  = 9;

  // Decode current states for clarity
  wire S     = state[S_bit];
  wire S1    = state[S1_bit];
  wire S11   = state[S11_bit];
  wire S110  = state[S110_bit];
  wire B0    = state[B0_bit];
  wire B1    = state[B1_bit];
  wire B2    = state[B2_bit];
  wire B3    = state[B3_bit];
  wire Count = state[Count_bit];
  wire Wait  = state[Wait_bit];

  // Next state logic derived by inspection and optimized factoring:
  // Next S state:
  //   from S(d=0), S1(d=0), S110(d=0), Wait(ack=1)
  assign S_next = ( (S | S1 | S110) & ~d ) | (Wait & ack);

  // Next S1 state: from S(d=1)
  assign S1_next = S & d;

  // Next B3 state: always from B2
  assign B3_next = B2;

  // Next Count state:
  //   from B3 (always)
  //   from Count(done_counting=0)
  assign Count_next = B3 | (Count & ~done_counting);

  // Next Wait state:
  //   from Count(done_counting=1)
  //   from Wait(ack=0)
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Moore outputs depend only on current state bits
  // shift_ena asserted during B0 through B3 (contiguous bits [4:7])
  assign shift_ena = |state[7:4];

  assign counting = Count;
  assign done     = Wait;

endmodule