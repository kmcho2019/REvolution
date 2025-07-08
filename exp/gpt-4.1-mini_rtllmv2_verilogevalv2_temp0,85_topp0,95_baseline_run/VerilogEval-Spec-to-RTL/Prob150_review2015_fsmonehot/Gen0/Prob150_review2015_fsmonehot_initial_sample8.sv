module TopModule (
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,       // one-hot encoded current state
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
wire S    = state[0];
wire S1   = state[1];
wire S11  = state[2];
wire S110 = state[3];
wire B0   = state[4];
wire B1   = state[5];
wire B2   = state[6];
wire B3   = state[7];
wire Count = state[8];
wire Wait  = state[9];

// Next state logic signals: assert if next state is that state

// Next state = S (bit 0) if:
// - From S with d=0
// - From S1 with d=0
// - From S110 with d=0
// - From Wait with ack=1
assign S_next = (S & ~d) 
              | (S1 & ~d) 
              | (S110 & ~d) 
              | (Wait & ack);

// Next state = S1 (bit 1) if:
// - From S with d=1
assign S1_next = (S & d);

// Next state = S11 (bit 2) if:
// - From S1 with d=1
// - From S11 with d=1 (loop)
wire S11_next = (S1 & d) | (S11 & d);
// No need to output S11_next as per interface

// Next state = S110 (bit 3) if:
// - From S11 with d=0
wire S110_next = (S11 & ~d);
// No output for S110_next required

// Next state = B0 (bit 4) if:
// - From S110 with d=1
wire B0_next = (S110 & d);
// No output for B0_next required

// Next state = B1 (bit 5) if:
// - From B0 (always)
wire B1_next = B0;
// No output for B1_next required

// Next state = B2 (bit 6) if:
// - From B1 (always)
wire B2_next = B1;
// No output for B2_next required

// Next state = B3 (bit 7) if:
// - From B2 (always)
assign B3_next = B2;

// Next state = Count (bit 8) if:
// - From B3 (always)
// - From Count with done_counting=0 (loop)
assign Count_next = (B3) | (Count & ~done_counting);

// Next state = Wait (bit 9) if:
// - From Count with done_counting=1
// - From Wait with ack=0 (loop)
assign Wait_next = (Count & done_counting) | (Wait & ~ack);

// Outputs (Moore, depend on current state):
assign shift_ena = B0 | B1 | B2 | B3;
assign counting  = Count;
assign done      = Wait;

endmodule