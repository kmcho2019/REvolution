module TopModule (
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

    // State encoding bits for convenience
    wire S    = state[0];
    wire S1   = state[1];
    wire S11  = state[2];
    wire S110 = state[3];
    wire B0   = state[4];
    wire B1   = state[5];
    wire B2   = state[6];
    wire B3_s = state[7];
    wire Count= state[8];
    wire Wait = state[9];

    // Next state logic (one-hot)
    // next S
    // From S: d=0 -> S
    // From S1: d=0 -> S
    // From S110: d=0 -> S
    // From Wait: ack=1 -> S
    wire S_n = 
        (S    & ~d) |
        (S1   & ~d) |
        (S110 & ~d) |
        (Wait & ack);

    // next S1
    // From S: d=1 -> S1
    wire S1_n = S & d;

    // next S11
    // From S1: d=1 -> S11
    // From S11: d=1 -> S11
    wire S11_n = (S1 & d) | (S11 & d);

    // next S110
    // From S11: d=0 -> S110
    wire S110_n = S11 & ~d;

    // next B0
    // From S110: d=1 -> B0
    wire B0_n = S110 & d;

    // next B1
    // From B0 -> B1
    wire B1_n = B0;

    // next B2
    // From B1 -> B2
    wire B2_n = B1;

    // next B3
    // From B2 -> B3
    wire B3_n = B2;

    // next Count
    // From B3 -> Count
    // From Count: done_counting=0 -> Count
    wire Count_n = (B3_s) | (Count & ~done_counting);

    // next Wait
    // From Count: done_counting=1 -> Wait
    // From Wait: ack=0 -> Wait
    wire Wait_n = (Count & done_counting) | (Wait & ~ack);

    // Outputs (Moore)
    assign shift_ena = B0 | B1 | B2 | B3_s;
    assign counting = Count;
    assign done = Wait;

    // Next state outputs - assert when next state is that state
    assign S_next = S_n;
    assign S1_next = S1_n;
    assign B3_next = B3_n;
    assign Count_next = Count_n;
    assign Wait_next = Wait_n;

endmodule