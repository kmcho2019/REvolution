module TopModule (
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,          // one-hot current state
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

wire S     = state[S_BIT];
wire S1    = state[S1_BIT];
wire S11   = state[S11_BIT];
wire S110  = state[S110_BIT];
wire B0    = state[B0_BIT];
wire B1    = state[B1_BIT];
wire B2    = state[B2_BIT];
wire B3    = state[B3_BIT];
wire Count = state[COUNT_BIT];
wire Wait  = state[WAIT_BIT];

// Intermediate signals for next state decoding
wire next_S;
wire next_S1;
wire next_B3;
wire next_Count;
wire next_Wait;

// Compute next-state signals:
assign next_S = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);
assign next_S1 = (S & d);
assign next_B3 = B2;
assign next_Count = B3 | (Count & ~done_counting);
assign next_Wait = (Count & done_counting) | (Wait & ~ack);

// Drive output next-state signals:
assign S_next     = next_S;
assign S1_next    = next_S1;
assign B3_next    = next_B3;
assign Count_next = next_Count;
assign Wait_next  = next_Wait;

// Moore output logic based on current state:
assign done      = Wait;
assign counting  = Count;
assign shift_ena = B0 | B1 | B2 | B3;

endmodule