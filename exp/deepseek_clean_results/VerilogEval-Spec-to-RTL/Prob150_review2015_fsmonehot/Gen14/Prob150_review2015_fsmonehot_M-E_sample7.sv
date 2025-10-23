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

    // Hierarchical state decoding
    wire S_curr     = state[0];
    wire S1_curr    = state[1];
    wire S11_curr   = state[2];
    wire S110_curr  = state[3];
    wire B_curr     = |state[6:4];  // B0-B3 group
    wire B0_curr    = state[4];
    wire B1_curr    = state[5];
    wire B2_curr    = state[6];
    wire B3_curr    = state[7];
    wire Count_curr = state[8];
    wire Wait_curr  = state[9];

    // Early output computation
    assign shift_ena = B_curr | B3_curr;  // Pre-compute for B states
    assign counting = Count_curr;
    assign done = Wait_curr;

    // State transition conditions
    wire d_rise = d;
    wire d_fall = ~d;
    wire counting_done = done_counting;
    wire ack_received = ack;

    // Grouped transition logic
    wire to_S = (S_curr & d_fall) | 
                (S1_curr & d_fall) | 
                (S110_curr & d_fall) | 
                (Wait_curr & ack_received);
    
    wire to_S1 = S_curr & d_rise;
    wire to_S11 = S1_curr & d_rise;
    wire to_S110 = S11_curr & d_fall;
    wire to_B0 = S110_curr & d_rise;
    
    // Sequential state progression
    wire to_B1 = B0_curr;
    wire to_B2 = B1_curr;
    wire to_B3 = B2_curr;
    
    wire to_Count = B3_curr | (Count_curr & ~counting_done);
    wire to_Wait = (Count_curr & counting_done) | (Wait_curr & ~ack_received);

    // Next state outputs
    assign S_next = to_S;
    assign S1_next = to_S1;
    assign B3_next = to_B3;
    assign Count_next = to_Count;
    assign Wait_next = to_Wait;

endmodule