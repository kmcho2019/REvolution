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

  // State bit indices for one-hot states
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

  // Intermediate signals for next state conditions
  wire S_from_S_d0     = S    & (~d);
  wire S_from_S1_d0    = S1   & (~d);
  wire S_from_S110_d0  = S110 & (~d);
  wire S_from_Wait_ack = Wait & ack;

  wire S1_from_S_d1    = S    & d;

  wire B3_from_B2      = B2;

  wire Count_from_B3            = B3;
  wire Count_stay_while_counting = Count & (~done_counting);

  wire Wait_from_Count_done     = Count & done_counting;
  wire Wait_stay_while_no_ack   = Wait & (~ack);

  // Combine intermediate next-state signals for outputs
  assign S_next     = S_from_S_d0 | S_from_S1_d0 | S_from_S110_d0 | S_from_Wait_ack;
  assign S1_next    = S1_from_S_d1;
  assign B3_next    = B3_from_B2;
  assign Count_next = Count_from_B3 | Count_stay_while_counting;
  assign Wait_next  = Wait_from_Count_done | Wait_stay_while_no_ack;

  // Moore outputs derived from current state
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule