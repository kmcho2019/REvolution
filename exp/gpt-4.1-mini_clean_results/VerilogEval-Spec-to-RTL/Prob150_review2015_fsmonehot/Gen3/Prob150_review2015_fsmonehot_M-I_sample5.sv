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

// State bits for readability
localparam S_bit    = 0;
localparam S1_bit   = 1;
localparam S11_bit  = 2;
localparam S110_bit = 3;
localparam B0_bit   = 4;
localparam B1_bit   = 5;
localparam B2_bit   = 6;
localparam B3_bit   = 7;
localparam Count_bit= 8;
localparam Wait_bit = 9;

wire S    = state[S_bit];
wire S1   = state[S1_bit];
wire S11  = state[S11_bit];
wire S110 = state[S110_bit];
wire B0   = state[B0_bit];
wire B1   = state[B1_bit];
wire B2   = state[B2_bit];
wire B3   = state[B3_bit];
wire Count = state[Count_bit];
wire Wait  = state[Wait_bit];

// Simplify next_state logic by reducing boolean expressions

// Next state for S:
// S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack)
// Simplify (S & ~d) | (S1 & ~d) = (S | S1) & ~d
wire S_next_expr = ((S | S1) & ~d) | (S110 & ~d) | (Wait & ack);

// Next state for S1:
// S1_next = S & d
wire S1_next_expr = S & d;

// Next state for S11:
// S11_next = (S1 & d) | (S11 & d) => (S1 | S11) & d
wire S11_next_expr = (S1 | S11) & d;

// Next state for S110:
// S110_next = S11 & ~d
wire S110_next_expr = S11 & ~d;

// Next state for B0:
// B0_next = S110 & d
wire B0_next_expr = S110 & d;

// Next state for B1:
// B1_next = B0
wire B1_next_expr = B0;

// Next state for B2:
// B2_next = B1
wire B2_next_expr = B1;

// Next state for B3:
// B3_next = B2
wire B3_next_expr = B2;

// Next state for Count:
// Count_next = B3 | (Count & ~done_counting)
wire Count_next_expr = B3 | (Count & ~done_counting);

// Next state for Wait:
// Wait_next = (Count & done_counting) | (Wait & ~ack)
wire Wait_next_expr = (Count & done_counting) | (Wait & ~ack);

// Assemble next_state vector (one-hot)
wire [9:0] next_state = {
    Wait_next_expr,
    Count_next_expr,
    B3_next_expr,
    B2_next_expr,
    B1_next_expr,
    B0_next_expr,
    S110_next_expr,
    S11_next_expr,
    S1_next_expr,
    S_next_expr
};

// Moore outputs from current state
assign done     = Wait;
assign counting = Count;
assign shift_ena= B0 | B1 | B2 | B3;

// Next-state indicators by selecting respective bits from next_state
assign B3_next    = next_state[B3_bit];
assign S_next     = next_state[S_bit];
assign S1_next    = next_state[S1_bit];
assign Count_next = next_state[Count_bit];
assign Wait_next  = next_state[Wait_bit];

endmodule