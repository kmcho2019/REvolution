module TopModule (
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

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

  // Next state signals (one-hot)
  assign S_next     = (state[S_bit] & ~d) | (state[S1_bit] & ~d) | (state[S110_bit] & ~d) | (state[Wait_bit] & ack);
  assign S1_next    = state[S_bit] & d;
  assign B3_next    = state[B2_bit];
  assign Count_next = state[B3_bit] | (state[Count_bit] & ~done_counting);
  assign Wait_next  = (state[Count_bit] & done_counting) | (state[Wait_bit] & ~ack);

  // Outputs
  assign shift_ena = state[B0_bit] | state[B1_bit] | state[B2_bit] | state[B3_bit];
  assign counting  = state[Count_bit];
  assign done      = state[Wait_bit];

endmodule