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

// Common sub-expression: (S|S1|S110) & ~d
wire s_d0 = (state[S_BIT] | state[S1_BIT] | state[S110_BIT]) & ~d;

// Next-state logic
assign S_next     = s_d0 | (state[WAIT_BIT] & ack);
assign S1_next    = state[S_BIT] & d;
assign B3_next    = state[B2_BIT];
assign Count_next = state[B3_BIT] | (state[COUNT_BIT] & ~done_counting);
assign Wait_next  = (state[COUNT_BIT] & done_counting) | (state[WAIT_BIT] & ~ack);

// Output logic (Moore outputs from current states)
assign done      = state[WAIT_BIT];
assign counting  = state[COUNT_BIT];
assign shift_ena = |state[B3_BIT:B0_BIT]; // OR reduction of B0, B1, B2, B3

endmodule