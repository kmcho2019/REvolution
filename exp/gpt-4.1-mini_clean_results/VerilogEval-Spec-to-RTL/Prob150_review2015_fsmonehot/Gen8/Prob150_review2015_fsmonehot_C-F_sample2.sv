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

// Localparams for state bit indices to improve readability
localparam S_bit     = 0;
localparam S1_bit    = 1;
localparam S11_bit   = 2;
localparam S110_bit  = 3;
localparam B0_bit    = 4;
localparam B1_bit    = 5;
localparam B2_bit    = 6;
localparam B3_bit    = 7;
localparam Count_bit = 8;
localparam Wait_bit  = 9;

// Current state signals decoded from one-hot input
wire S     = state[S_bit];
wire S1    = state[S1_bit];
wire S11   = state[S11_bit];
wire S110  = state[S110_bit];
wire B0    = state[B0_bit];
wire B1    = state[B1_bit];
wire B2    = state[B2_bit];
wire B3    = state[B3_bit];
wire Count = state[Count_bit];
wire Wait  = state[Wait_bit];

// Next-state signals for only the states required as outputs

// S_next:
// From S(d=0), S1(d=0), S110(d=0), Wait(ack=1)
assign S_next = (S & ~d)
              | (S1 & ~d)
              | (S110 & ~d)
              | (Wait & ack);

// S1_next:
// From S(d=1)
assign S1_next = S & d;

// B3_next:
// From B2 (always next)
assign B3_next = B2;

// Count_next:
// From B3 (always next) or stay in Count if done_counting=0
assign Count_next = B3 | (Count & ~done_counting);

// Wait_next:
// From Count(done_counting=1) or stay in Wait if ack=0
assign Wait_next = (Count & done_counting) | (Wait & ~ack);

// Moore outputs (derived from current state bits)
assign done     = Wait;
assign counting = Count;
assign shift_ena = B0 | B1 | B2 | B3;

endmodule