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

// State bit indices for readability
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

// Current state bits
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

// Next state signals (all one-hot, intermediate wires)
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

// Next-state logic (factorized and clear):

// S_next: from S, S1, S110 with d=0; Wait with ack=1
wire any_S_states_d0 = (S | S1 | S110) & ~d;
S_next_w = any_S_states_d0 | (Wait & ack);

// S1_next: from S with d=1
S1_next_w = S & d;

// S11_next: from S1 or S11 with d=1
S11_next_w = (S1 | S11) & d;

// S110_next: from S11 with d=0
S110_next_w = S11 & ~d;

// B0_next: from S110 with d=1
B0_next_w = S110 & d;

// B1_next: from B0 (always next cycle)
B1_next_w = B0;

// B2_next: from B1 (always next cycle)
B2_next_w = B1;

// B3_next: from B2 (always next cycle)
B3_next_w = B2;

// Count_next: from B3 (always next cycle) or Count with done_counting=0
Count_next_w = B3 | (Count & ~done_counting);

// Wait_next: from Count done_counting=1 or Wait ack=0
Wait_next_w = (Count & done_counting) | (Wait & ~ack);

// Output next-state signals (only some of the full next-state vector)
assign B3_next   = B3_next_w;
assign S_next    = S_next_w;
assign S1_next   = S1_next_w;
assign Count_next= Count_next_w;
assign Wait_next = Wait_next_w;

// Moore outputs depend only on current state bits
assign done      = Wait;
assign counting  = Count;
assign shift_ena = B0 | B1 | B2 | B3;

endmodule