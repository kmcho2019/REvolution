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

// State bit indices for clarity
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

// Decode current states
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

// Next state logic

// Next state S can come from S, S1, S110 when d=0, or from Wait when ack=1
wire S_next_from_d0_states = ~d & (S | S1 | S110);
wire S_next_from_wait_ack  = WAIT & ack;
assign S_next = S_next_from_d0_states | S_next_from_wait_ack;

// Next state S1 comes only from S with d=1
assign S1_next = S & d;

// B3 next is simply when current is B2 (always progresses)
assign B3_next = B2;

// Count next occurs when current is B3 or stays in Count with done_counting=0
assign Count_next = B3 | (COUNT & ~done_counting);

// Wait next occurs when done_counting=1 during Count or stays in Wait when ack=0
assign Wait_next = (COUNT & done_counting) | (WAIT & ~ack);

// Outputs are Moore outputs derived solely from current state
assign shift_ena = B0 | B1 | B2 | B3;
assign counting  = COUNT;
assign done      = WAIT;

endmodule