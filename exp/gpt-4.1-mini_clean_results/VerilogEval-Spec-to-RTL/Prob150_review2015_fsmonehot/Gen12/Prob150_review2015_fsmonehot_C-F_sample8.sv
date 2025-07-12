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

// Next-state conditions from state transitions
// From states with input-dependent transitions
wire S_next_from_S     = S    & ~d;
wire S_next_from_S1    = S1   & ~d;
wire S_next_from_S110  = S110 & ~d;
wire S_next_from_Wait  = WAIT & ack;

wire S1_next_from_S    = S    & d;

wire S11_next_from_S1  = S1  & d;
wire S11_next_from_S11 = S11 & d;

wire S110_next_from_S11 = S11 & ~d;

wire B0_next_from_S110 = S110 & d;

// From states with fixed-next cycle transitions
wire B1_next_from_B0 = B0;
wire B2_next_from_B1 = B1;
wire B3_next_from_B2 = B2;

wire Count_next_from_B3 = B3;
wire Count_next_stay    = COUNT & ~done_counting;

wire Wait_next_from_Count_done = COUNT & done_counting;
wire Wait_next_stay            = WAIT & ~ack;

// Assign next-state outputs combining conditions
assign S_next = S_next_from_S | S_next_from_S1 | S_next_from_S110 | S_next_from_Wait;
assign S1_next = S1_next_from_S;
assign B3_next = B3_next_from_B2;
assign Count_next = Count_next_from_B3 | Count_next_stay;
assign Wait_next = Wait_next_from_Count_done | Wait_next_stay;

// (Optional) Though not requested, define next states for completeness
// Not output signals but for completeness (can be removed or retained)
wire S11_next  = S11_next_from_S1 | S11_next_from_S11;
wire S110_next = S110_next_from_S11;
wire B0_next   = B0_next_from_S110;
wire B1_next   = B1_next_from_B0;
wire B2_next   = B2_next_from_B1;

// Moore outputs from current state
assign shift_ena = B0 | B1 | B2 | B3;
assign counting  = COUNT;
assign done      = WAIT;

endmodule