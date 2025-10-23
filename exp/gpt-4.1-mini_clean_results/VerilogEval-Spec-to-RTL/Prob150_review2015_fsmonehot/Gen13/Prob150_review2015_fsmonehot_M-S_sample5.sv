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

// One-hot state bits index
localparam S     = 0;
localparam S1    = 1;
localparam S11   = 2;
localparam S110  = 3;
localparam B0    = 4;
localparam B1    = 5;
localparam B2    = 6;
localparam B3    = 7;
localparam Count = 8;
localparam Wait  = 9;

// Next-state assignments
assign S_next     = (state[S] & ~d) | (state[S1] & ~d) | (state[S110] & ~d) | (state[Wait] & ack);
assign S1_next    = state[S] & d;
assign S11_next   = (state[S1] & d) | (state[S11] & d);
assign S110_next  = state[S11] & ~d;
assign B0_next    = state[S110] & d;
assign B1_next    = state[B0];
assign B2_next    = state[B1];
assign B3_next    = state[B2];
assign Count_next = state[B3] | (state[Count] & ~done_counting);
assign Wait_next  = (state[Count] & done_counting) | (state[Wait] & ~ack);

// Moore outputs
assign done      = state[Wait];
assign counting  = state[Count];
assign shift_ena = state[B0] | state[B1] | state[B2] | state[B3];

endmodule