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

// State bits mapping (one-hot encoding)
// S     = state[0]
// S1    = state[1]
// S11   = state[2]
// S110  = state[3]
// B0    = state[4]
// B1    = state[5]
// B2    = state[6]
// B3    = state[7]
// Count = state[8]
// Wait  = state[9]

wire S     = state[0];
wire S1    = state[1];
wire S11   = state[2];
wire S110  = state[3];
wire B0    = state[4];
wire B1    = state[5];
wire B2    = state[6];
wire B3    = state[7];
wire Count = state[8];
wire Wait  = state[9];

// Next state logic for all states (one-hot encoding)
wire S_next_w;
wire S1_next_w;
wire S11_next_w;
wire S110_next_w;
wire B0_next_w;
wire B1_next_w;
wire B2_next_w;
wire B3_next_w;
wire Count_next_w;
wire Wait_next_w;

// Derive next state for each FSM state based on transition table and inputs

// S_next: 
// From S (d=0) -> S
// From S1 (d=0) -> S
// From S110 (d=0) -> S
// From Wait (ack=1) -> S
assign S_next_w = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

// S1_next:
// From S (d=1) -> S1
assign S1_next_w = S & d;

// S11_next:
// From S1 (d=1) -> S11
// From S11 (d=1) -> S11
assign S11_next_w = (S1 | S11) & d;

// S110_next:
// From S11 (d=0) -> S110
assign S110_next_w = S11 & ~d;

// B0_next:
// From S110 (d=1) -> B0
assign B0_next_w = S110 & d;

// B1_next:
// From B0 (always) -> B1
assign B1_next_w = B0;

// B2_next:
// From B1 (always) -> B2
assign B2_next_w = B1;

// B3_next:
// From B2 (always) -> B3
assign B3_next_w = B2;

// Count_next:
// From B3 (always) -> Count
// From Count (done_counting=0) -> Count
assign Count_next_w = B3 | (Count & ~done_counting);

// Wait_next:
// From Count (done_counting=1) -> Wait
// From Wait (ack=0) -> Wait
assign Wait_next_w = (Count & done_counting) | (Wait & ~ack);

// Output next-state signals (only these 5 next states are outputs)
assign B3_next  = B3_next_w;
assign S_next   = S_next_w;
assign S1_next  = S1_next_w;
assign Count_next = Count_next_w;
assign Wait_next  = Wait_next_w;

// Moore outputs depend only on current state bits
assign done      = Wait;
assign counting  = Count;
assign shift_ena = B0 | B1 | B2 | B3;

endmodule