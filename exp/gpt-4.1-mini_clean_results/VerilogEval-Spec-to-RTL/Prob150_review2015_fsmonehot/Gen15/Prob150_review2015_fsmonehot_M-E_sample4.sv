module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,        // One-hot encoded states: bit0=S ... bit9=Wait
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// State bit indices for readability
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

// Current state signals
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

// Next state logic - define each next state signal by OR of conditions leading to that state
assign S_next = 
       (S     & ~d)       // S --d=0--> S
    |  (S1    & ~d)       // S1 --d=0--> S
    |  (S110  & ~d)       // S110 --d=0--> S
    |  (WAIT   & ack);    // Wait --ack=1--> S

assign S1_next = 
       (S      & d);       // S --d=1--> S1

assign B3_next = 
       (B2);              // B2 --always--> B3

assign Count_next = 
       (B3)               // B3 --always--> Count
    |  (COUNT & ~done_counting); // Count --done_counting=0--> Count

assign Wait_next = 
       (COUNT & done_counting)    // Count --done_counting=1--> Wait
    |  (WAIT  & ~ack);           // Wait --ack=0--> Wait

// Additional intermediate next states for completeness
wire S11_next = (S1 & d) | (S11 & d);          // S1 or S11 and d=1 --> S11
wire S110_next = (S11 & ~d);                    // S11 and d=0 --> S110
wire B0_next = (S110 & d);                      // S110 and d=1 --> B0
wire B1_next = B0;                              // B0 always--> B1
wire B2_next = B1;                              // B1 always--> B2

// Though only asked for certain next states as outputs, for completeness, local signals
// For user clarity we leave them internal (not outputs).

// Output logic as Moore outputs derived from current state
assign done      = WAIT;
assign counting  = COUNT;
assign shift_ena = B0 | B1 | B2 | B3;

endmodule