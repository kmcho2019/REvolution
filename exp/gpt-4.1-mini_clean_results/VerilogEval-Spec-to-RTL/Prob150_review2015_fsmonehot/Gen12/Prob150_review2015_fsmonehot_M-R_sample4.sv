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

// Next state assignments by inspection from FSM diagram (one-hot next states)

// Next S state:
// From S with d=0
// From S1 with d=0
// From S110 with d=0
// From Wait with ack=1
assign S_next = ( (S | S1 | S110) & ~d ) | (WAIT & ack);

// Next S1 state:
// From S with d=1
assign S1_next = S & d;

// Next S11 state:
// From S1 with d=1
// From S11 with d=1
// Not output, but needed to confirm state transition completeness (not requested as output)

// Next S110 state:
// From S11 with d=0
// Not output, so omitted

// Next B0 state:
// From S110 with d=1
// Not output, so omitted

// Next B1 state:
// From B0 (always)
assign /* unused */ B1_next = B0; // no output port for B1_next

// Next B2 state:
// From B1 (always)
assign /* unused */ B2_next = B1; // no output port for B2_next

// Next B3 state:
// From B2 (always)
assign B3_next = B2;

// Next Count state:
// From B3 (always)
// From Count with done_counting=0
assign Count_next = B3 | (COUNT & ~done_counting);

// Next Wait state:
// From Count with done_counting=1
// From Wait with ack=0
assign Wait_next = (COUNT & done_counting) | (WAIT & ~ack);

// Outputs
assign done      = WAIT;
assign counting  = COUNT;
assign shift_ena = B0 | B1 | B2 | B3;

endmodule