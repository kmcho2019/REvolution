module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// State bits for readability (one-hot)
// Bit positions (from LSB=0):
// S    = state[0]
// S1   = state[1]
// S11  = state[2]
// S110 = state[3]
// B0   = state[4]
// B1   = state[5]
// B2   = state[6]
// B3   = state[7]
// Count= state[8]
// Wait = state[9]

wire S    = state[0];
wire S1   = state[1];
wire S11  = state[2];
wire S110 = state[3];
wire B0   = state[4];
wire B1   = state[5];
wire B2   = state[6];
wire B3   = state[7];
wire Count= state[8];
wire Wait = state[9];

// Next state logic for each state

// Next S:
// From S with d=0 -> S
// From S1 with d=0 -> S
// From S11 with d=0 -> S110 but no S
// From S110 with d=0 -> S
// From Wait with ack=1 -> S

assign S_next = 
      (S    & ~d)
    | (S1   & ~d)
    | (S110 & ~d)
    | (Wait &  ack);

// Next S1:
// From S with d=1 -> S1
// From S1 with d=1 -> S11 but no S1
assign S1_next = 
      (S & d);

// Next B3:
// From B2 -> B3 (always)
assign B3_next = B2;

// Next Count:
// From B3 -> Count (always)
assign Count_next = B3;

// Next Wait:
// From Count with done_counting=1 -> Wait
// From Wait with ack=0 -> Wait
assign Wait_next = (Count & done_counting) | (Wait & ~ack);

// Outputs (Moore), depend on current state

assign shift_ena = B0 | B1 | B2 | B3;
assign counting  = Count;
assign done      = Wait;

endmodule