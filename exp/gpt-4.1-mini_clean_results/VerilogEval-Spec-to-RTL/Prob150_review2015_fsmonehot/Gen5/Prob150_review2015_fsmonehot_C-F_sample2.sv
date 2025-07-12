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

// State bit indices for readability and maintainability
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

// Current state bits as wires for clarity
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

// Next state one-hot vector: each bit corresponds to a next state
// Derived by inspection and simplified logic

wire [9:0] next_state;

assign next_state[S_bit] =
      (S & ~d)
    | (S1 & ~d)
    | (S110 & ~d)
    | (Wait & ack);

assign next_state[S1_bit] = S & d;

// S11_next covers two transitions: (S1 & d) and (S11 & d)
// Also (S11 & ~d) leads to S110, so no redundant terms here
assign next_state[S11_bit] = (S1 & d) | (S11 & d);

// S110 next state when (S11 & ~d)
assign next_state[S110_bit] = S11 & ~d;

// B0 next when (S110 & d)
assign next_state[B0_bit] = S110 & d;

// B1 next when current state B0 (always)
assign next_state[B1_bit] = B0;

// B2 next when current state B1 (always)
assign next_state[B2_bit] = B1;

// B3 next when current state B2 (always)
assign next_state[B3_bit] = B2;

// Count next when B3 or (Count & ~done_counting)
assign next_state[Count_bit] = B3 | (Count & ~done_counting);

// Wait next when (Count & done_counting) or (Wait & ~ack)
assign next_state[Wait_bit] = (Count & done_counting) | (Wait & ~ack);

// Outputs: Moore outputs depend only on current state

assign shift_ena = B0 | B1 | B2 | B3;
assign counting  = Count;
assign done      = Wait;

// Export next-state signals from next_state vector

assign S_next     = next_state[S_bit];
assign S1_next    = next_state[S1_bit];
assign B3_next    = next_state[B3_bit];
assign Count_next = next_state[Count_bit];
assign Wait_next  = next_state[Wait_bit];

endmodule