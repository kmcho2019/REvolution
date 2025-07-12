module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,       // One-hot: bit0=S ... bit9=Wait
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

    // State bits
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

    // Next state logic for requested outputs

    // Next S: from S,S1,S110 on d=0; from Wait on ack=1
    assign S_next = ( (S | S1 | S110) & ~d ) | (Wait & ack);

    // Next S1: from S on d=1
    assign S1_next = S & d;

    // Next B3: from B2 (always next)
    assign B3_next = B2;

    // Next Count: from B3 always, or stay in Count if done_counting=0
    assign Count_next = B3 | (Count & ~done_counting);

    // Next Wait: from Count if done_counting=1, or stay in Wait if ack=0
    assign Wait_next = (Count & done_counting) | (Wait & ~ack);

    // Outputs based on current state (Moore)
    assign done     = Wait;
    assign counting = Count;
    assign shift_ena= B0 | B1 | B2 | B3;

endmodule