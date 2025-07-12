module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,  // one-hot: bit0=S ... bit9=Wait
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

    // Define state bits for clarity
    localparam S    = 0;
    localparam S1   = 1;
    localparam S11  = 2;
    localparam S110 = 3;
    localparam B0   = 4;
    localparam B1   = 5;
    localparam B2   = 6;
    localparam B3   = 7;
    localparam Count = 8;
    localparam Wait  = 9;

    // Common conditions to reduce repeated logic
    wire s_states = state[S] | state[S1] | state[S110];
    wire b_states = state[B0] | state[B1] | state[B2] | state[B3];

    // Next-state logic
    assign S_next = (s_states & ~d) | (state[Wait] & ack);
    assign S1_next = state[S] & d;
    assign B3_next = state[B2];
    assign Count_next = state[B3] | (state[Count] & ~done_counting);
    assign Wait_next = (state[Count] & done_counting) | (state[Wait] & ~ack);

    // Outputs from current state (Moore outputs)
    assign done = state[Wait];
    assign counting = state[Count];
    assign shift_ena = b_states;

endmodule