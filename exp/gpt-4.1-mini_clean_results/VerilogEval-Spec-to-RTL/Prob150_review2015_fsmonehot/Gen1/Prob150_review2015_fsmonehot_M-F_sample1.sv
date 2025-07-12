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

    // One-hot encoding positions for readability
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

    // Next-state signals - one-hot next state vector bits
    wire next_S;
    wire next_S1;
    wire next_S11;
    wire next_S110;
    wire next_B0;
    wire next_B1;
    wire next_B2;
    wire next_B3;
    wire next_Count;
    wire next_Wait;

    // Next-state logic by inspection from current state and inputs

    // next S:
    // From S: d=0 --> S
    // From S1: d=0 --> S
    // From S110: d=0 --> S
    // From Wait: ack=1 --> S
    assign next_S = (S & ~d)      // from S with d=0
                  | (S1 & ~d)     // from S1 with d=0
                  | (S110 & ~d)   // from S110 with d=0
                  | (Wait & ack); // from Wait with ack=1

    // next S1:
    // From S: d=1 --> S1
    assign next_S1 = S & d;

    // next S11:
    // From S1: d=1 --> S11
    // From S11: d=1 --> S11 (self-loop)
    assign next_S11 = (S1 & d) | (S11 & d);

    // next S110:
    // From S11: d=0 --> S110
    assign next_S110 = S11 & ~d;

    // next B0:
    // From S110: d=1 --> B0
    assign next_B0 = S110 & d;

    // next B1:
    // From B0: always to B1
    assign next_B1 = B0;

    // next B2:
    // From B1: always to B2
    assign next_B2 = B1;

    // next B3:
    // From B2: always to B3
    assign next_B3 = B2;

    // next Count:
    // From B3: always to Count
    // From Count: done_counting=0 stay Count
    assign next_Count = B3 | (Count & ~done_counting);

    // next Wait:
    // From Count: done_counting=1 --> Wait
    // From Wait: ack=0 --> Wait
    assign next_Wait = (Count & done_counting) | (Wait & ~ack);

    // Connect computed next-state signals to output ports (fix missing assignments)
    assign S_next     = next_S;
    assign S1_next    = next_S1;
    assign B3_next    = next_B3;
    assign Count_next = next_Count;
    assign Wait_next  = next_Wait;

    // Outputs: Based on next state (Moore machine output)
    assign shift_ena = next_B0 | next_B1 | next_B2 | next_B3;
    assign counting  = next_Count;
    assign done      = next_Wait;

endmodule