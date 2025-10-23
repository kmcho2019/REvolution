module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Next state logic for each possible current state
    wire s0_next_0 = state[0] & ~in;  // S0 -> S0 when in=0
    wire s0_next_1 = state[0] & in;   // S0 -> S1 when in=1
    
    wire s1_next_0 = state[1] & ~in;  // S1 -> S0 when in=0
    wire s1_next_2 = state[1] & in;   // S1 -> S2 when in=1
    
    wire s2_next_0 = state[2] & ~in;  // S2 -> S0 when in=0
    wire s2_next_3 = state[2] & in;   // S2 -> S3 when in=1
    
    wire s3_next_0 = state[3] & ~in;  // S3 -> S0 when in=0
    wire s3_next_4 = state[3] & in;   // S3 -> S4 when in=1
    
    wire s4_next_0 = state[4] & ~in;  // S4 -> S0 when in=0
    wire s4_next_5 = state[4] & in;   // S4 -> S5 when in=1
    
    wire s5_next_8 = state[5] & ~in;  // S5 -> S8 when in=0
    wire s5_next_6 = state[5] & in;   // S5 -> S6 when in=1
    
    wire s6_next_9 = state[6] & ~in;  // S6 -> S9 when in=0
    wire s6_next_7 = state[6] & in;   // S6 -> S7 when in=1
    
    wire s7_next_0 = state[7] & ~in;  // S7 -> S0 when in=0
    wire s7_next_7 = state[7] & in;   // S7 -> S7 when in=1
    
    wire s8_next_0 = state[8] & ~in;  // S8 -> S0 when in=0
    wire s8_next_1 = state[8] & in;   // S8 -> S1 when in=1
    
    wire s9_next_0 = state[9] & ~in;  // S9 -> S0 when in=0
    wire s9_next_1 = state[9] & in;   // S9 -> S1 when in=1

    // Combine all possible next states
    assign next_state[0] = s0_next_0 | s1_next_0 | s2_next_0 | s3_next_0 | 
                          s4_next_0 | s7_next_0 | s8_next_0 | s9_next_0;
    assign next_state[1] = s0_next_1 | s8_next_1 | s9_next_1;
    assign next_state[2] = s1_next_2;
    assign next_state[3] = s2_next_3;
    assign next_state[4] = s3_next_4;
    assign next_state[5] = s4_next_5;
    assign next_state[6] = s5_next_6;
    assign next_state[7] = s6_next_7 | s7_next_7;
    assign next_state[8] = s5_next_8;
    assign next_state[9] = s6_next_9;

    // Output logic (only active in S7, S8, S9)
    assign out1 = state[8] | state[9];  // S8 or S9
    assign out2 = state[7] | state[9];  // S7 or S9

endmodule