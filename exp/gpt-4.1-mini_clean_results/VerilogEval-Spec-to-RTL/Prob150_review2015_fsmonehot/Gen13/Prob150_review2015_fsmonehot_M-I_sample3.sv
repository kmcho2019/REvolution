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

// Simplified next-state logic by factoring common terms

// Next state S: from S, S1, S110 on d=0, and from Wait on ack=1
wire S_next_expr = ((S | S1 | S110) & ~d) | (Wait & ack);

// Next state S1: from S on d=1
wire S1_next_expr = S & d;

// Next state S11: from S1 or S11 on d=1
wire S11_next_expr = (S1 | S11) & d;

// Next state S110: from S11 on d=0
wire S110_next_expr = S11 & ~d;

// Next state B0: from S110 on d=1
wire B0_next_expr = S110 & d;

// Next states B1, B2, B3: move sequentially without input conditions
wire B1_next_expr = B0;
wire B2_next_expr = B1;
wire B3_next_expr = B2;

// Count: from B3 or hold when done_counting=0
wire Count_next_expr = B3 | (Count & ~done_counting);

// Wait: from Count when done_counting=1 or hold when ack=0
wire Wait_next_expr = (Count & done_counting) | (Wait & ~ack);

// Compose next_state vector (one-hot)
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

// shift_ena asserted during B0,B1,B2,B3 states - use next_state to reduce fan-in
assign shift_ena= next_state[B0_bit] | next_state[B1_bit] | next_state[B2_bit] | next_state[B3_bit];

// Next-state indicators
assign B3_next    = next_state[B3_bit];
assign S_next     = next_state[S_bit];
assign S1_next    = next_state[S1_bit];
assign Count_next = next_state[Count_bit];
assign Wait_next  = next_state[Wait_bit];

endmodule