module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot encoded state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Named state bit positions (one-hot encoding)
localparam S     = 0;
localparam S1    = 1;
localparam S11   = 2;
localparam S110  = 3;
localparam B0    = 4;
localparam B1    = 5;
localparam B2    = 6;
localparam B3    = 7;
localparam COUNT = 8;
localparam WAIT  = 9;

// Next state logic - simplified direct assignments
assign S_next    = (state[S] & ~d) | (state[S1] & ~d) | (state[S110] & ~d) | (state[WAIT] & ack);
assign S1_next   = state[S] & d;
assign B3_next   = state[B2];
assign Count_next = state[B3] | (state[COUNT] & ~done_counting);
assign Wait_next = (state[COUNT] & done_counting) | (state[WAIT] & ~ack);

// Output logic - direct state bit usage
assign done      = state[WAIT];
assign counting  = state[COUNT];
assign shift_ena = |state[B0:B3];  // OR reduction of B states

endmodule