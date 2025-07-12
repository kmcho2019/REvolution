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

// State bits for convenience
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

// Next state logic for each state (one-hot)
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

assign next_S = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);
assign next_S1 = (S & d);
assign next_S11 = (S1 & d) | (S11 & d);
assign next_S110 = (S11 & ~d);
assign next_B0 = (S110 & d);
assign next_B1 = B0;
assign next_B2 = B1;
assign next_B3 = B2;
assign next_Count = B3 | (Count & ~done_counting);
assign next_Wait = (Count & done_counting) | (Wait & ~ack);

// Output signals from next state
assign B3_next = next_B3;
assign S_next = next_S;
assign S1_next = next_S1;
assign Count_next = next_Count;
assign Wait_next = next_Wait;

// Outputs based on current state (Moore outputs)
assign done = Wait;
assign counting = Count;
assign shift_ena = B0 | B1 | B2 | B3;

endmodule