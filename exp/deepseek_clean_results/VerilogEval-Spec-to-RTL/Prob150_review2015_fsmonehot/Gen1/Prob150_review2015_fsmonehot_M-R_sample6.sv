module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// One-hot state encoding
localparam S      = 0;
localparam S1     = 1;
localparam S11    = 2;
localparam S110   = 3;
localparam B0     = 4;
localparam B1     = 5;
localparam B2     = 6;
localparam B3     = 7;
localparam Count  = 8;
localparam Wait   = 9;

// Internal next-state signals
wire S11_next, S110_next, B0_next, B1_next, B2_next;

// Next state logic - fully specified transitions
assign S_next = (~d & (state[S] | state[S1] | state[S110])) | 
                (state[Wait] & ack);

assign S1_next = (state[S] & d) | 
                 (state[S1] & d);

assign S11_next = state[S1] & d;

assign S110_next = state[S11] & ~d;

assign B0_next = state[S110] & d;

assign B1_next = state[B0];

assign B2_next = state[B1];

assign B3_next = state[B2];

assign Count_next = state[B3];

assign Wait_next = state[Count] & done_counting;

// Output logic - purely based on current state
assign done = state[Wait];
assign counting = state[Count];
assign shift_ena = state[B0] | state[B1] | state[B2] | state[B3];

endmodule