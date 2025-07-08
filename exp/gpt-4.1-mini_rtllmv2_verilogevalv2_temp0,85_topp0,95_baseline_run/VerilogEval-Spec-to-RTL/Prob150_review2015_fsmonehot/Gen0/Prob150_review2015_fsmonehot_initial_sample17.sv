module TopModule (
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,       // one-hot current state
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

    // State bits for clarity
    wire S    = state[0];
    wire S1   = state[1];
    wire S11  = state[2];
    wire S110 = state[3];
    wire B0   = state[4];
    wire B1   = state[5];
    wire B2   = state[6];
    wire B3_s = state[7];  // renamed to avoid confusion with output B3_next
    wire Count= state[8];
    wire Wait = state[9];

    // Next state logic equations derived by inspection:

    // Next state S (bit 0):
    // from S and d=0
    // from S1 and d=0
    // from S110 and d=0
    // from Wait and ack=1
    assign S_next = (S    & ~d) | 
                    (S1   & ~d) |
                    (S110 & ~d) |
                    (Wait  & ack);

    // Next state S1 (bit 1):
    // from S and d=1
    assign S1_next = S & d;

    // Next state S11 (bit 2):
    // from S1 and d=1
    // from S11 and d=1 (loop)
    assign S11_next = (S1  & d) | 
                      (S11 & d);

    // Next state S110 (bit 3):
    // from S11 and d=0
    assign S110_next = S11 & ~d;

    // Next state B0 (bit 4):
    // from S110 and d=1
    assign B0_next = S110 & d;

    // Next state B1 (bit 5):
    // from B0 unconditionally
    assign B1_next = B0;

    // Next state B2 (bit 6):
    // from B1 unconditionally
    assign B2_next = B1;

    // Next state B3 (bit 7):
    // from B2 unconditionally
    assign B3_next = B2;

    // Next state Count (bit 8):
    // from B3 unconditionally
    // from Count and done_counting=0 (loop)
    assign Count_next = (B3_s) | (Count & ~done_counting);

    // Next state Wait (bit 9):
    // from Count and done_counting=1
    // from Wait and ack=0 (loop)
    assign Wait_next = (Count & done_counting) | (Wait & ~ack);

    // Outputs based on current state (Moore machine):

    // done = 1 in Wait state
    assign done = Wait;

    // counting = 1 in Count state
    assign counting = Count;

    // shift_ena = 1 in B0,B1,B2,B3 states
    assign shift_ena = B0 | B1 | B2 | B3_s;

endmodule