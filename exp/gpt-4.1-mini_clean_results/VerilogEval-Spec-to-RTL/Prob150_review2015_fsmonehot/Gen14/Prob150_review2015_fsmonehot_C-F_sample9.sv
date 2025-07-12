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

// State bit indices (one-hot encoding)
localparam S_BIT     = 0;
localparam S1_BIT    = 1;
localparam S11_BIT   = 2;
localparam S110_BIT  = 3;
localparam B0_BIT    = 4;
localparam B1_BIT    = 5;
localparam B2_BIT    = 6;
localparam B3_BIT    = 7;
localparam COUNT_BIT = 8;
localparam WAIT_BIT  = 9;

// Extract current state signals
wire S     = state[S_BIT];
wire S1    = state[S1_BIT];
wire S11   = state[S11_BIT];
wire S110  = state[S110_BIT];
wire B0    = state[B0_BIT];
wire B1    = state[B1_BIT];
wire B2    = state[B2_BIT];
wire B3    = state[B3_BIT];
wire COUNT = state[COUNT_BIT];
wire WAIT  = state[WAIT_BIT];

// Common sub-expression to simplify next-state logic
wire s_d0 = (S | S1 | S110) & (~d);

// Next-state logic for requested next states
assign S_next     = s_d0 | (WAIT & ack);
assign S1_next    = S & d;
assign B3_next    = B2;
assign Count_next = B3 | (COUNT & ~done_counting);
assign Wait_next  = (COUNT & done_counting) | (WAIT & ~ack);

// Moore outputs derived directly from current states
assign done      = WAIT;
assign counting  = COUNT;
assign shift_ena = B0 | B1 | B2 | B3;

endmodule