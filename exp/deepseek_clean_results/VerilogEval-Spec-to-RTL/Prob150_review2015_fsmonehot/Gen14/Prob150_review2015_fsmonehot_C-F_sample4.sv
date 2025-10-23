module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot: S=bit0, S1=bit1, S11=bit2, S110=bit3,
                        // B0=bit4, B1=bit5, B2=bit6, B3=bit7, Count=bit8, Wait=bit9
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Current state decoding with descriptive names
    wire current_S     = state[0];
    wire current_S1    = state[1];
    wire current_S11   = state[2];
    wire current_S110  = state[3];
    wire current_B0    = state[4];
    wire current_B1    = state[5];
    wire current_B2    = state[6];
    wire current_B3    = state[7];
    wire current_Count = state[8];
    wire current_Wait  = state[9];

    // State transition conditions (modular approach)
    wire s_stays_S     = current_S & ~d;
    wire s1_says_S     = current_S1 & ~d;
    wire s110_says_S   = current_S110 & ~d;
    wire wait_says_S   = current_Wait & ack;

    wire s_says_S1     = current_S & d;

    wire b2_says_B3    = current_B2;

    wire b3_says_Count = current_B3;
    wire count_holds   = current_Count & ~done_counting;

    wire count_says_Wait = current_Count & done_counting;
    wire wait_holds      = current_Wait & ~ack;

    // Next state logic (grouped by destination)
    assign S_next     = s_stays_S | s1_says_S | s110_says_S | wait_says_S;
    assign S1_next    = s_says_S1;
    assign B3_next    = b2_says_B3;
    assign Count_next = b3_says_Count | count_holds;
    assign Wait_next  = count_says_Wait | wait_holds;

    // Output logic (direct state assignments)
    assign shift_ena = current_B0 | current_B1 | current_B2 | current_B3;
    assign counting  = current_Count;
    assign done      = current_Wait;

endmodule