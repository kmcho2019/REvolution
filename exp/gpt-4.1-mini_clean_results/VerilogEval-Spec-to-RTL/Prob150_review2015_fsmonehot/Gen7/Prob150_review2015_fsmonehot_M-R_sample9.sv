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

// State bit indices
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

// Current state signals for clarity
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

// Next-state logic by state individually defined for clarity
wire next_S;
wire next_S1;
wire next_S11;
wire next_S110;
wire next_B0;
wire next_B1;
wire next_B2;
wire next_B3;
wire next_Count;
wire next_Wait;

// S next state: from S or S1 or S110 with d=0, or from Wait with ack=1
assign next_S = ((S | S1 | S110) & ~d) | (Wait & ack);

// S1 next state: from S with d=1
assign next_S1 = S & d;

// S11 next state: from S1 or S11 with d=1
assign next_S11 = (S1 | S11) & d;

// S110 next state: from S11 with d=0
assign next_S110 = S11 & ~d;

// B0 next state: from S110 with d=1
assign next_B0 = S110 & d;

// B1 next state: from B0
assign next_B1 = B0;

// B2 next state: from B1
assign next_B2 = B1;

// B3 next state: from B2
assign next_B3 = B2;

// Count next state: from B3 or from Count while not done_counting
assign next_Count = B3 | (Count & ~done_counting);

// Wait next state: from Count when done_counting, or Wait if ack is 0
assign next_Wait = (Count & done_counting) | (Wait & ~ack);

// Assemble next_state vector one-hot
wire [9:0] next_state = {
    next_Wait,
    next_Count,
    next_B3,
    next_B2,
    next_B1,
    next_B0,
    next_S110,
    next_S11,
    next_S1,
    next_S
};

// Moore outputs from current state
assign done     = Wait;
assign counting = Count;
assign shift_ena= B0 | B1 | B2 | B3;

// Outputs indicating next-state asserted
assign B3_next    = next_B3;
assign S_next     = next_S;
assign S1_next    = next_S1;
assign Count_next = next_Count;
assign Wait_next  = next_Wait;

endmodule