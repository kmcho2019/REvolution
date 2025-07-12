module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,        // one-hot encoding
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// State bit positions
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

// Current state signals
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

// Next state signals - simplified and combined

// Next state S:
// S_next = ((S | S1 | S110) & ~d) | (Wait & ack)
wire s_d0 = (S | S1 | S110) & (~d);
wire S_next_expr = s_d0 | (Wait & ack);

// Next state S1:
// S1_next = S & d
wire S1_next_expr = S & d;

// Next state S11:
// S11_next = (S1 | S11) & d
wire S11_next_expr = (S1 | S11) & d;

// Next state S110:
// S110_next = S11 & ~d
wire S110_next_expr = S11 & (~d);

// Next state B0:
// B0_next = S110 & d
wire B0_next_expr = S110 & d;

// Next states B1, B2, B3 are simple shifts:
wire B1_next_expr = B0;
wire B2_next_expr = B1;
wire B3_next_expr = B2;

// Next state Count:
// Count_next = B3 | (Count & ~done_counting)
wire Count_next_expr = B3 | (Count & ~done_counting);

// Next state Wait:
// Wait_next = (Count & done_counting) | (Wait & ~ack)
wire Wait_next_expr = (Count & done_counting) | (Wait & ~ack);

// Outputs (Moore)
// done asserted when in Wait state
assign done = Wait;
// counting asserted when in Count state
assign counting = Count;
// shift_ena asserted when in any B state (B0 to B3)
assign shift_ena = B0 | B1 | B2 | B3;

// Output next-state indicators directly from expressions
assign S_next     = S_next_expr;
assign S1_next    = S1_next_expr;
assign B3_next    = B3_next_expr;
assign Count_next = Count_next_expr;
assign Wait_next  = Wait_next_expr;

endmodule