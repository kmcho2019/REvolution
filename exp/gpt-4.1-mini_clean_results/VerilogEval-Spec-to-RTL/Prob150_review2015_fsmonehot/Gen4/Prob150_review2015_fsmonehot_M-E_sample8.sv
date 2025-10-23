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

// Extract current state bits
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

// Next state signals (one-hot)
wire next_S;
wire next_S1;
wire next_S11;
wire next_S110;
wire next_B0;
wire next_B1;
wire next_B2;
wire next_B3;
wire next_COUNT;
wire next_WAIT;

// Next state logic from FSM description
assign next_S    = (S    & ~d)            // S->S if d=0
                 | (S1   & ~d)            // S1->S if d=0
                 | (S110  & ~d)           // S110->S if d=0
                 | (WAIT  & ack);         // WAIT->S if ack=1

assign next_S1   = (S    & d);             // S->S1 if d=1

assign next_S11  = (S1   & d)             // S1->S11 if d=1
                 | (S11  & d);             // S11->S11 if d=1

assign next_S110 = (S11  & ~d);            // S11->S110 if d=0

assign next_B0   = (S110 & d);             // S110->B0 if d=1

assign next_B1   = B0;                      // B0->B1 always

assign next_B2   = B1;                      // B1->B2 always

assign next_B3   = B2;                      // B2->B3 always

assign next_COUNT= (B3)                   // B3->COUNT always
                 | (COUNT & ~done_counting);  // COUNT->COUNT if not done_counting

assign next_WAIT = (COUNT & done_counting)  // COUNT->WAIT if done_counting
                 | (WAIT & ~ack);            // WAIT->WAIT if ack=0

assign done      = WAIT;                    // done output asserted in WAIT state
assign counting  = COUNT;                   // counting output asserted in COUNT state
assign shift_ena = B0 | B1 | B2 | B3;      // shift_ena asserted in B0..B3

// Generate next-state assertion outputs for requested states
assign B3_next    = next_B3;
assign S_next     = next_S;
assign S1_next    = next_S1;
assign Count_next = next_COUNT;
assign Wait_next  = next_WAIT;

endmodule