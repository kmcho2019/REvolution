module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Current state
    wire S     = state[0];
    wire S1    = state[1];
    wire S11   = state[2];
    wire S110  = state[3];
    wire B0    = state[4];
    wire B1    = state[5];
    wire B2    = state[6];
    wire B3    = state[7];
    wire Count = state[8];
    wire Wait  = state[9];

    // Next-state logic equations (first level)
    assign B3_next = (state[6] && d) || (state[6] && ~d); // B2 always goes to B3
    assign S_next  = (state[0] && ~d) || (state[1] && ~d) || (state[3] && ~d) || (state[9] && ack);
    assign S1_next = (state[0] && d);
    assign Count_next = (state[7]) || (state[8] && ~done_counting);
    assign Wait_next = (state[8] && done_counting) || (state[9] && ~ack);

    // Output logic equations (second level)
    assign done      = state[9];
    assign counting  = state[8];
    assign shift_ena = state[4] || state[5] || state[6] || state[7];

endmodule