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

    wire S, S1, S11, S110, B0, B1, B2, B3, Count, Wait;

    assign S     = state[0];
    assign S1    = state[1];
    assign S11   = state[2];
    assign S110  = state[3];
    assign B0    = state[4];
    assign B1    = state[5];
    assign B2    = state[6];
    assign B3    = state[7];
    assign Count = state[8];
    assign Wait  = state[9];

    // Next state logic
    assign B3_next = (B2 && (d || ~d)); // B2 always goes to B3
    assign S_next = (S && ~d) || (S1 && ~d) || (S110 && ~d) || (Wait && ack);
    assign S1_next = (S && d);
    assign Count_next = (B3) || (Count && ~done_counting);
    assign Wait_next = (Count && done_counting) || (Wait && ~ack);

    // Output logic
    assign done = Wait;
    assign counting = Count;
    assign shift_ena = B0 || B1 || B2 || B3;

endmodule