module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,       // one-hot: bit0=S ... bit9=Wait
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
localparam S_BIT    = 0;
localparam S1_BIT   = 1;
localparam S11_BIT  = 2;
localparam S110_BIT = 3;
localparam B0_BIT   = 4;
localparam B1_BIT   = 5;
localparam B2_BIT   = 6;
localparam B3_BIT   = 7;
localparam COUNT_BIT= 8;
localparam WAIT_BIT = 9;

// Current states
wire S    = state[S_BIT];
wire S1   = state[S1_BIT];
wire S11  = state[S11_BIT];
wire S110 = state[S110_BIT];
wire B0   = state[B0_BIT];
wire B1   = state[B1_BIT];
wire B2   = state[B2_BIT];
wire B3   = state[B3_BIT];
wire COUNT= state[COUNT_BIT];
wire WAIT = state[WAIT_BIT];

// Next state logic
assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (WAIT & ack);
assign S1_next = S & d;
assign Count_next = (B3) | (COUNT & ~done_counting);
assign Wait_next = (COUNT & done_counting) | (WAIT & ~ack);
assign B3_next = B2;
 
// For states S11, S110, B0, B1, B2 next states:
wire next_S11  = (S1 & d) | (S11 & d);
wire next_S110 = S11 & ~d;
wire next_B0   = S110 & d;
wire next_B1   = B0;
wire next_B2   = B1;

// shift_ena when in B0..B3 states next cycle
assign shift_ena = B0 | B1 | B2 | B3;
assign counting = COUNT;
assign done = WAIT;

// Assign the remaining next state signals (not output ports)
wire S11_next = next_S11;
wire S110_next = next_S110;
wire B0_next = next_B0;
wire B1_next = next_B1;
wire B2_next = next_B2;

endmodule