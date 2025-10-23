module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Next state bits from each state, to be ORed together
    wire [9:0] ns_s0, ns_s1, ns_s2, ns_s3, ns_s4, ns_s5, ns_s6, ns_s7, ns_s8, ns_s9;
    wire       out1_s7, out2_s7, out1_s8, out2_s8, out1_s9, out2_s9;

    // S0 transitions
    assign ns_s0 = (state[0]) ?
                   (in ? 10'b0000000010 : 10'b0000000001) : 10'b0;
    // S1 transitions
    assign ns_s1 = (state[1]) ?
                   (in ? 10'b0000000100 : 10'b0000000001) : 10'b0;
    // S2 transitions
    assign ns_s2 = (state[2]) ?
                   (in ? 10'b0000001000 : 10'b0000000001) : 10'b0;
    // S3 transitions
    assign ns_s3 = (state[3]) ?
                   (in ? 10'b0000010000 : 10'b0000000001) : 10'b0;
    // S4 transitions
    assign ns_s4 = (state[4]) ?
                   (in ? 10'b0000100000 : 10'b0000000001) : 10'b0;
    // S5 transitions
    assign ns_s5 = (state[5]) ?
                   (in ? 10'b0001000000 : 10'b1000000000) : 10'b0;
    // S6 transitions
    assign ns_s6 = (state[6]) ?
                   (in ? 10'b0010000000 : 10'b1000000000) : 10'b0;
    // S7 transitions
    assign ns_s7 = (state[7]) ?
                   (in ? 10'b0000100000 : 10'b0000000001) : 10'b0;
    // S8 transitions
    assign ns_s8 = (state[8]) ?
                   (in ? 10'b0000000010 : 10'b0000000001) : 10'b0;
    // S9 transitions
    assign ns_s9 = (state[9]) ?
                   (in ? 10'b0000000010 : 10'b0000000001) : 10'b0;

    // Combine next states from all active states
    assign next_state = ns_s0 | ns_s1 | ns_s2 | ns_s3 | ns_s4 | ns_s5 | ns_s6 | ns_s7 | ns_s8 | ns_s9;

    // Outputs contributed by states with non-zero outputs
    assign out1_s7 = 1'b0;
    assign out2_s7 = state[7];        // S7 outputs (0,1)

    assign out1_s8 = state[8];        // S8 outputs (1,0)
    assign out2_s8 = 1'b0;

    assign out1_s9 = state[9];        // S9 outputs (1,1)
    assign out2_s9 = state[9];

    // Combine outputs from all active states
    assign out1 = out1_s8 | out1_s9;
    assign out2 = out2_s7 | out2_s9;

endmodule