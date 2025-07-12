module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,      // one-hot encoding
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// State bit indices according to one-hot encoding
localparam S_bit     = 0; // S      = 10'b0000000001
localparam S1_bit    = 1; // S1     = 10'b0000000010
localparam S11_bit   = 2; // S11    = 10'b0000000100
localparam S110_bit  = 3; // S110   = 10'b0000001000
localparam B0_bit    = 4; // B0     = 10'b0000010000
localparam B1_bit    = 5; // B1     = 10'b0000100000
localparam B2_bit    = 6; // B2     = 10'b0001000000
localparam B3_bit    = 7; // B3     = 10'b0010000000
localparam Count_bit = 8; // Count  = 10'b0100000000
localparam Wait_bit  = 9; // Wait   = 10'b1000000000

// Extract current state bits for convenience
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

// Next state logic derived by inspection:

// Next S state:
// From S when d=0
// From S1 when d=0
// From S110 when d=0
// From Wait when ack=1
wire next_S_from_S = S     & (~d);
wire next_S_from_S1 = S1   & (~d);
wire next_S_from_S110 = S110 & (~d);
wire next_S_from_Wait = Wait & ack;
wire S_next_expr = next_S_from_S | next_S_from_S1 | next_S_from_S110 | next_S_from_Wait;

// Next S1 state:
// From S when d=1
wire S1_next_expr = S & d;

// Next S11 state:
// From S1 when d=1
// From S11 when d=1 (self loop)
wire S11_next_expr = (S1 | S11) & d;

// Next S110 state:
// From S11 when d=0
wire S110_next_expr = S11 & (~d);

// Next B0 state:
// From S110 when d=1
wire B0_next_expr = S110 & d;

// Next B1 state:
// Always from B0 (always go to next cycle)
wire B1_next_expr = B0;

// Next B2 state:
// Always from B1
wire B2_next_expr = B1;

// Next B3 state:
// Always from B2
wire B3_next_expr = B2;

// Next Count state:
// From B3
// Stay in Count if done_counting=0
wire Count_next_expr = B3 | (Count & (~done_counting));

// Next Wait state:
// From Count when done_counting=1
// Stay in Wait if ack=0
wire Wait_next_expr = (Count & done_counting) | (Wait & (~ack));

// Outputs (Moore outputs depend only on current state)
// done asserted in Wait state
assign done = Wait;

// counting asserted in Count state
assign counting = Count;

// shift_ena asserted in states B0, B1, B2, B3
assign shift_ena = B0 | B1 | B2 | B3;

// Output indicators if next state is specific states
assign S_next     = S_next_expr;
assign S1_next    = S1_next_expr;
assign B3_next    = B3_next_expr;
assign Count_next = Count_next_expr;
assign Wait_next  = Wait_next_expr;

endmodule