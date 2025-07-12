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

// Next-state logic directly as expressions:
wire [9:0] next_state;
assign next_state[S_bit] = ((S | S1 | S110) & ~d) | (Wait & ack);
assign next_state[S1_bit] = S & d;
assign next_state[S11_bit] = (S1 | S11) & d;
assign next_state[S110_bit] = S11 & ~d;
assign next_state[B0_bit] = S110 & d;
assign next_state[B1_bit] = B0;
assign next_state[B2_bit] = B1;
assign next_state[B3_bit] = B2;
assign next_state[Count_bit] = B3 | (Count & ~done_counting);
assign next_state[Wait_bit] = (Count & done_counting) | (Wait & ~ack);

// Moore outputs from current state:
assign done     = Wait;
assign counting = Count;
assign shift_ena= B0 | B1 | B2 | B3;

// Output next-state indicators:
assign B3_next    = next_state[B3_bit];
assign S_next     = next_state[S_bit];
assign S1_next    = next_state[S1_bit];
assign Count_next = next_state[Count_bit];
assign Wait_next  = next_state[Wait_bit];

endmodule