module TopModule(
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

    // State encoding (one-hot)
    wire S    = state[0];
    wire S1   = state[1];
    wire S11  = state[2];
    wire S110 = state[3];
    wire B0   = state[4];
    wire B1   = state[5];
    wire B2   = state[6];
    wire B3   = state[7];
    wire Count= state[8];
    wire Wait = state[9];

    // Next state logic by inspection from the problem statement

    // S_next (next state is S)
    // S: d=0 -> S
    // S1: d=0 -> S
    // S110: d=0 -> S
    // Wait: ack=1 -> S
    assign S_next = (S   & ~d) 
                  | (S1  & ~d) 
                  | (S110 & ~d)
                  | (Wait & ack);

    // S1_next (next state is S1)
    // S: d=1 -> S1
    assign S1_next = (S & d);

    // S11_next
    // S1: d=1 -> S11
    // S11: d=1 -> S11
    // Not requested as output, but used internally

    // S11_next = S1 & d | S11 & d;

    // S110_next
    // S11: d=0 -> S110
    // Not requested as output

    // B0_next
    // S110: d=1 -> B0

    // B1_next
    // B0: always -> B1

    // B2_next
    // B1: always -> B2

    // B3_next
    // B2: always -> B3
    assign B3_next = B2;

    // Count_next
    // B3: always -> Count
    assign Count_next = B3;

    // Wait_next
    // Count: done_counting=1 -> Wait
    assign Wait_next = Count & done_counting;

    // Outputs by current state
    assign shift_ena = B0 | B1 | B2 | B3;
    assign counting  = Count;
    assign done      = Wait;

endmodule