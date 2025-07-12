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

    // Optimized next-state logic equations
    assign B3_next = B2;  // Simplified
    assign S_next = (~d && (S || S1 || S110)) || (Wait && ack);  // Factored out common terms
    assign S1_next = d && S;  // Simplified
    assign Count_next = B3 || (Count && ~done_counting);  // Simplified
    assign Wait_next = (Count && done_counting) || (Wait && ~ack);  // Simplified

    // Output logic equations (unchanged, as they are already simplified)
    assign done = Wait;
    assign counting = Count;
    assign shift_ena = (B0 || B1 || B2 || B3);

    // No change in the FSM approach, as the one-hot encoding is efficient
    // and the combinational logic is already optimized.

endmodule