module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Current state decoding (one-hot)
    wire S_curr     = state[0];
    wire S1_curr    = state[1];
    wire S11_curr   = state[2];
    wire S110_curr  = state[3];
    wire B0_curr    = state[4];
    wire B1_curr    = state[5];
    wire B2_curr    = state[6];
    wire B3_curr    = state[7];
    wire Count_curr = state[8];
    wire Wait_curr  = state[9];

    // Intermediate transition conditions
    wire s_to_s1    = S_curr & d;
    wire s1_to_s11  = S1_curr & d;
    wire s11_to_s110= S11_curr & ~d;
    wire s110_to_b0 = S110_curr & d;
    wire wait_to_s  = Wait_curr & ack;
    
    wire return_to_S = (S_curr | S1_curr | S110_curr) & ~d;
    wire stay_in_count = Count_curr & ~done_counting;
    wire count_to_wait = Count_curr & done_counting;
    wire stay_in_wait = Wait_curr & ~ack;

    // Next state logic
    assign S_next     = return_to_S | wait_to_s;
    assign S1_next    = s_to_s1;
    assign B3_next    = B2_curr;
    assign Count_next = B3_curr | stay_in_count;
    assign Wait_next  = count_to_wait | stay_in_wait;

    // Output logic (Moore machine)
    assign shift_ena = B0_curr | B1_curr | B2_curr | B3_curr;
    assign counting  = Count_curr;
    assign done      = Wait_curr;

endmodule