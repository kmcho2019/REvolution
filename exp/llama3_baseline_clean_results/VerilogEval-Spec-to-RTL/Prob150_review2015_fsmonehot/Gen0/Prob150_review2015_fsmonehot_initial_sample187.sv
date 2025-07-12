module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // One-hot encoding for states
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

    // Next state logic
    assign S_next     = (~S & ~S1 & ~S11 & ~S110 & ~B0 & ~B1 & ~B2 & ~B3 & ~Count & ~Wait) ? 1'b0 :
                        (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack) ? 1'b1 : 1'b0;
    assign S1_next    = (S & d) ? 1'b1 : 1'b0;
    assign B3_next    = (B2) ? 1'b1 : 1'b0;
    assign Count_next = (B3) ? 1'b1 : 1'b0;
    assign Wait_next  = (Count & done_counting) ? 1'b1 : 1'b0;

    // Output logic
    assign shift_ena = B0 | B1 | B2 | B3;
    assign counting  = Count;
    assign done      = Wait;

endmodule