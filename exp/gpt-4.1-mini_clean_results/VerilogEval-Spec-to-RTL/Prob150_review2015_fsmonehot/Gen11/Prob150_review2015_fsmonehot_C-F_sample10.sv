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

// State bit indices for clarity
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

// Decode current states
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

// Next-state logic (combined and factored for minimal logic depth)

// Next S: from S(d=0), S1(d=0), S110(d=0), Wait(ack=1)
wire S_next_early = (S | S1 | S110) & ~d;
wire S_next       = S_next_early | (Wait & ack);

// Next S1: only from S(d=1)
wire S1_next = S & d;

// Next B3: only from B2 (always next cycle)
wire B3_next = B2;

// Next Count: from B3 and stay in Count while done_counting=0
wire Count_next = B3 | (Count & ~done_counting);

// Next Wait: from Count(done_counting=1) and Wait(~ack)
wire Wait_next = (Count & done_counting) | (Wait & ~ack);

// Outputs: Moore outputs depend on current state only
wire shift_ena = B0 | B1 | B2 | B3;
wire counting  = Count;
wire done      = Wait;

assign B3_next = B3_next;
assign S_next = S_next;
assign S1_next = S1_next;
assign Count_next = Count_next;
assign Wait_next = Wait_next;

assign shift_ena = shift_ena;
assign counting = counting;
assign done = done;

endmodule