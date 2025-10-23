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

    // One-hot state encoding definitions
    localparam S     = 10'b0000000001;
    localparam S1    = 10'b0000000010;
    localparam S11   = 10'b0000000100;
    localparam S110  = 10'b0000001000;
    localparam B0    = 10'b0000010000;
    localparam B1    = 10'b0000100000;
    localparam B2    = 10'b0001000000;
    localparam B3    = 10'b0010000000;
    localparam Count = 10'b0100000000;
    localparam Wait  = 10'b1000000000;

    // Current state signals
    wire is_S      = state[0];
    wire is_S1     = state[1];
    wire is_S11    = state[2];
    wire is_S110   = state[3];
    wire is_B0     = state[4];
    wire is_B1     = state[5];
    wire is_B2     = state[6];
    wire is_B3     = state[7];
    wire is_Count  = state[8];
    wire is_Wait   = state[9];

    // Next state logic
    assign S_next = (is_S & ~d) | (is_S1 & ~d) | (is_S110 & ~d) | (is_Wait & ack);
    assign S1_next = is_S & d;
    assign B3_next = is_B2;
    assign Count_next = is_B3 | (is_Count & ~done_counting);
    assign Wait_next = (is_Count & done_counting) | (is_Wait & ~ack);

    // Output logic
    assign shift_ena = is_B0 | is_B1 | is_B2 | is_B3;
    assign counting = is_Count;
    assign done = is_Wait;

endmodule