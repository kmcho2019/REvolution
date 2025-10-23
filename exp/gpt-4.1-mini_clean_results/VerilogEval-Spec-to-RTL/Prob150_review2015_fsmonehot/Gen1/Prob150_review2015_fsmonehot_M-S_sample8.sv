module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state, // one-hot encoded states: S=bit0, S1=bit1, ..., Wait=bit9
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // State bit indices
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

    // Next-state logic (one-hot)
    assign S_next = (state[S]   & ~d) |
                    (state[S1]  & ~d) |
                    (state[S110] & ~d) |
                    (state[Wait] &  ack);

    assign S1_next = state[S] & d;

    assign B3_next = state[B2];

    assign Count_next = state[B3] |
                        (state[Count] & ~done_counting);

    assign Wait_next = (state[Count] & done_counting) |
                       (state[Wait]  & ~ack);

    // Output logic (Moore outputs depend on current state)
    assign shift_ena = state[B0] | state[B1] | state[B2] | state[B3];
    assign counting  = state[Count];
    assign done      = state[Wait];

endmodule