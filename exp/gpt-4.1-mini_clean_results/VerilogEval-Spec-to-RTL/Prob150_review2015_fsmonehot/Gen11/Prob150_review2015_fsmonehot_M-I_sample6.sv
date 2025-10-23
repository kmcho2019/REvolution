module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,       // one-hot encoded states
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

// Group states that go to S on d=0
wire s_states = S | S1 | S110;

// Next-state logic

// Next S: from S, S1, S110 when d=0; and from Wait when ack=1
assign S_next = (s_states & ~d) | (Wait & ack);

// Next S1: from S when d=1
assign S1_next = S & d;

// Next B3: from B2 (always next cycle)
assign B3_next = B2;

// Next Count: from B3 and Count (counting continues until done_counting=1)
assign Count_next = B3 | (Count & ~done_counting);

// Next Wait: from Count(done_counting=1) and Wait(~ack)
assign Wait_next = (Count & done_counting) | (Wait & ~ack);

// Outputs (Moore outputs depend only on current state)
assign done      = Wait;
assign counting  = Count;
assign shift_ena = B0 | B1 | B2 | B3;

endmodule