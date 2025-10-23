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

    // Next-state logic equations
    assign B3_next = B2;
    assign S_next  = (~d && (S || S1 || S110)) || (ack && Wait);
    assign S1_next = d && S;
    assign Count_next = B3 || (~done_counting && Count);
    assign Wait_next = (done_counting && Count) || (~ack && Wait);

    // Output logic equations
    assign done      = Wait;
    assign counting  = Count;
    assign shift_ena = B0 || B1 || B2 || B3;

    // Clock gating for power reduction
    wire clk_enable = shift_ena;
    wire clk_gated = clk_enable? clk : 1'b0;

endmodule