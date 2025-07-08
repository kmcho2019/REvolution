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

    // State bits for clarity (one-hot)
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

    // Next state logic by inspection from FSM and one-hot encoding:

    // Next S state:
    // From S: if d=0 -> S
    // From S1: if d=0 -> S
    // From S110: if d=0 -> S
    // From Wait: if ack=1 -> S
    wire nextS_from_S    = S    & ~d;
    wire nextS_from_S1   = S1   & ~d;
    wire nextS_from_S110 = S110 & ~d;
    wire nextS_from_Wait = Wait & ack;

    assign S_next = nextS_from_S | nextS_from_S1 | nextS_from_S110 | nextS_from_Wait;

    // Next S1 state:
    // From S: if d=1 -> S1
    assign S1_next = S & d;

    // Next S11 state:
    // From S1: if d=1 -> S11
    // This output is not requested, so no signal for S11_next

    // Next S110 state:
    // From S11: if d=0 -> S110
    // Also not requested

    // Next B0 state:
    // From S110: if d=1 -> B0
    // Not requested

    // Next B1 state:
    // From B0: always next cycle -> B1
    // Not requested

    // Next B2 state:
    // From B1: always next cycle -> B2
    // Not requested

    // Next B3 state:
    // From B2: always next cycle -> B3
    assign B3_next = B2;

    // Next Count state:
    // From B3: always next cycle -> Count
    assign Count_next = B3;

    // Next Wait state:
    // From Count: if done_counting=1 -> Wait
    assign Wait_next = Count & done_counting;

    // Outputs:
    // done = Wait state
    assign done = Wait;

    // counting = Count state
    assign counting = Count;

    // shift_ena = B0 or B1 or B2 or B3 states
    assign shift_ena = B0 | B1 | B2 | B3;

endmodule