module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state signals for each state transition
    wire [9:0] ns_s0, ns_s1, ns_s2, ns_s3, ns_s4, ns_s5, ns_s6, ns_s7, ns_s8, ns_s9;

    // From S0
    assign ns_s0[0] = state[0] & ~in;
    assign ns_s0[1] = state[0] & in;
    assign ns_s0[9:2] = 8'b0;

    // From S1
    assign ns_s1[0] = state[1] & ~in;
    assign ns_s1[2] = state[1] & in;
    assign ns_s1[9:3] = 7'b0;

    // From S2
    assign ns_s2[0] = state[2] & ~in;
    assign ns_s2[3] = state[2] & in;
    assign ns_s2[9:4] = 6'b0;

    // From S3
    assign ns_s3[0] = state[3] & ~in;
    assign ns_s3[4] = state[3] & in;
    assign ns_s3[9:5] = 5'b0;

    // From S4
    assign ns_s4[0] = state[4] & ~in;
    assign ns_s4[5] = state[4] & in;
    assign ns_s4[9:6] = 4'b0;

    // From S5
    assign ns_s5[8] = state[5] & ~in;
    assign ns_s5[6] = state[5] & in;
    assign ns_s5[5:0] = 6'b0;
    assign ns_s5[9] = 1'b0;

    // From S6
    assign ns_s6[9] = state[6] & ~in;
    assign ns_s6[7] = state[6] & in;
    assign ns_s6[6:0] = 7'b0;

    // From S7
    assign ns_s7[0] = state[7] & ~in;
    assign ns_s7[7] = state[7] & in;
    assign ns_s7[9:8] = 2'b0;

    // From S8
    assign ns_s8[0] = state[8] & ~in;
    assign ns_s8[1] = state[8] & in;
    assign ns_s8[9:2] = 8'b0;

    // From S9
    assign ns_s9[0] = state[9] & ~in;
    assign ns_s9[1] = state[9] & in;
    assign ns_s9[9:2] = 8'b0;

    // Combine next states from all current active states (OR)
    assign next_state = ns_s0 | ns_s1 | ns_s2 | ns_s3 | ns_s4 | ns_s5 | ns_s6 | ns_s7 | ns_s8 | ns_s9;

    // Outputs from active states: 
    // out1=1 for S8 only, out2=1 for S7 only, else 0
    assign out1 = state[8];
    assign out2 = state[7];

endmodule