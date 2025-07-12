module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,        // one-hot encoding of current state
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

    // Current state bits in one-hot encoding:
    // bit0 = S, bit1 = S1, bit2 = S11, bit3 = S110,
    // bit4 = B0, bit5 = B1, bit6 = B2, bit7 = B3,
    // bit8 = Count, bit9 = Wait

    // Next-state assignments by direct boolean logic:

    // Next S state:
    // From S,d=0; S1,d=0; S110,d=0; WAIT,ack=1
    assign S_next  = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack);

    // Next S1 state:
    // From S,d=1
    assign S1_next = state[0] & d;

    // Next B3 state:
    // From B2 (always)
    assign B3_next = state[6];

    // Next Count state:
    // From B3 (always)
    // Stay in Count if done_counting=0
    assign Count_next = state[7] | (state[8] & ~done_counting);

    // Next Wait state:
    // From Count when done_counting=1
    // Stay in Wait if ack=0
    assign Wait_next = (state[8] & done_counting) | (state[9] & ~ack);

    // Moore output logic from current state bits:
    assign shift_ena = state[4] | state[5] | state[6] | state[7]; // B0..B3
    assign counting  = state[8]; // Count
    assign done      = state[9]; // Wait

endmodule