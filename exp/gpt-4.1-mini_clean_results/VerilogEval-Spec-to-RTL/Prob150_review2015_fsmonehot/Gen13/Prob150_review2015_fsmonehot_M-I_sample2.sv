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

// State bit positions (one-hot)
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

// Current state signals
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

// Factor common terms to optimize logic
wire d0 = ~d; 
wire s_s1_s110 = S | S1 | S110;
wire s1_s11 = S1 | S11;

// Next state logic

// S_next: next state S is when ((S|S1|S110) & ~d) or (Wait & ack)
assign S_next = (s_s1_s110 & d0) | (Wait & ack);

// S1_next: from S on d=1
assign S1_next = S & d;

// B3_next: next is B2 (direct pass)
assign B3_next = B2;

// Count_next: B3 or (Count and not done_counting)
assign Count_next = B3 | (Count & ~done_counting);

// Wait_next: (Count & done_counting) or (Wait & ~ack)
assign Wait_next = (Count & done_counting) | (Wait & ~ack);

// Outputs (Moore):
assign done     = Wait;                  // done asserted in Wait state
assign counting = Count;                 // counting asserted in Count state
assign shift_ena = B0 | B1 | B2 | B3;   // shift_ena asserted in B states

endmodule