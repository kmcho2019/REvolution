module TopModule (
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

    // current state bits for readability
    wire S    = state[0];
    wire S1   = state[1];
    wire S11  = state[2];
    wire S110 = state[3];
    wire B0   = state[4];
    wire B1   = state[5];
    wire B2   = state[6];
    wire B3   = state[7];
    wire Count = state[8];
    wire Wait = state[9];

    // Next state logic for each next state (one-hot)
    // S_next:
    // from S on d=0 -> S
    // from S1 on d=0 -> S
    // from S110 on d=0 -> S
    // from Wait on ack=1 -> S
    assign S_next =
           (S    & ~d)
        |  (S1   & ~d)
        |  (S110 & ~d)
        |  (Wait & ack);

    // S1_next:
    // from S on d=1 -> S1
    assign S1_next = (S & d);

    // B3_next:
    // from B2 always -> B3
    assign B3_next = B2;

    // Count_next:
    // from B3 always -> Count
    assign Count_next = B3;

    // Wait_next:
    // from Count on done_counting=1 -> Wait
    // from Wait on ack=0 -> Wait
    assign Wait_next =
           (Count & done_counting)
        |  (Wait & ~ack);

    // shift_ena output:
    // asserted for B0,B1,B2,B3 states
    assign shift_ena = B0 | B1 | B2 | B3;

    // counting output:
    // asserted for Count state
    assign counting = Count;

    // done output:
    // asserted for Wait state
    assign done = Wait;

endmodule