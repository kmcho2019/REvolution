module TopModule (
  input        d,
  input        done_counting,
  input        ack,
  input  [9:0] state, // 10-bit one-hot current state
  output       B3_next,
  output       S_next,
  output       S1_next,
  output       Count_next,
  output       Wait_next,
  output       done,
  output       counting,
  output       shift_ena
);

// State encoding indices for clarity
localparam S_i    = 0;
localparam S1_i   = 1;
localparam S11_i  = 2;
localparam S110_i = 3;
localparam B0_i   = 4;
localparam B1_i   = 5;
localparam B2_i   = 6;
localparam B3_i   = 7;
localparam Count_i= 8;
localparam Wait_i = 9;

// Next state logic by inspection:

assign S_next = (state[S_i]    & ~d) |  // S->S on d=0
                (state[S1_i]   & ~d) |  // S1->S on d=0
                (state[S110_i] & ~d) |  // S110->S on d=0
                (state[Wait_i] & ack);  // Wait->S on ack=1

assign S1_next = (state[S_i] & d);        // S->S1 on d=1

assign B3_next = state[B2_i];              // B2->B3 (always)

assign Count_next = state[B3_i];           // B3->Count (always)

assign Wait_next = state[Count_i] & done_counting; // Count->Wait when done_counting=1

// Output logic by inspection:

assign done     = state[Wait_i];

assign counting = state[Count_i];

assign shift_ena = state[B0_i] | state[B1_i] | state[B2_i] | state[B3_i];

endmodule