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

// State bit indices (for clarity)
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

// Next state logic (one-hot) derived by inspection:

// S_next: (S|S1|S110)&~d or WAIT&ack
assign S_next = ((state[S_BIT] | state[S1_BIT] | state[S110_BIT]) & ~d) | (state[WAIT_BIT] & ack);

// S1_next: S&d
assign S1_next = state[S_BIT] & d;

// B3_next: next state after B2, which is always next cycle from B2
assign B3_next = state[B2_BIT];

// Count_next: from B3 (always) or Count with done_counting=0
assign Count_next = state[B3_BIT] | (state[COUNT_BIT] & ~done_counting);

// Wait_next: Count with done_counting=1 or Wait with ack=0
assign Wait_next = (state[COUNT_BIT] & done_counting) | (state[WAIT_BIT] & ~ack);

// Outputs:
// done = Wait state active
assign done = state[WAIT_BIT];

// counting = Count state active
assign counting = state[COUNT_BIT];

// shift_ena = any of B0,B1,B2,B3 active (bits 4 to 7)
// Use OR reduction on slice for efficient logic
assign shift_ena = |state[7:4];

endmodule