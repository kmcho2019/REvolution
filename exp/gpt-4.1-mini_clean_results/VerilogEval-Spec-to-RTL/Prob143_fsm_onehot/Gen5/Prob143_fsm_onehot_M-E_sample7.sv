module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);
    // Per-state next_state vectors (one-hot)
    wire [9:0] ns_S0, ns_S1, ns_S2, ns_S3, ns_S4, ns_S5, ns_S6, ns_S7, ns_S8, ns_S9;

    // S0 transitions
    assign ns_S0 = (state[0]) ? ((in) ? 10'b0000000010 : 10'b0000000001) : 10'b0; 
    // If in=1 -> S1; else S0

    // S1 transitions
    assign ns_S1 = (state[1]) ? ((in) ? 10'b0000000100 : 10'b0000000001) : 10'b0;
    // If in=1 -> S2; else S0

    // S2 transitions
    assign ns_S2 = (state[2]) ? ((in) ? 10'b0000001000 : 10'b0000000001) : 10'b0;
    // If in=1 -> S3; else S0

    // S3 transitions
    assign ns_S3 = (state[3]) ? ((in) ? 10'b0000010000 : 10'b0000000001) : 10'b0;
    // If in=1 -> S4; else S0

    // S4 transitions
    assign ns_S4 = (state[4]) ? ((in) ? 10'b0000100000 : 10'b0000000001) : 10'b0;
    // If in=1 -> S5; else S0

    // S5 transitions
    assign ns_S5 = (state[5]) ? ((in) ? 10'b0000010000 : 10'b0001000000) : 10'b0;
    // If in=1 -> S6; else S8

    // S6 transitions
    assign ns_S6 = (state[6]) ? ((in) ? 10'b0100000000 : 10'b1000000000) : 10'b0;
    // If in=1 -> S7; else S9

    // S7 transitions
    assign ns_S7 = (state[7]) ? ((in) ? 10'b1000000000 : 10'b0000000001) : 10'b0;
    // If in=1 -> S7; else S0

    // S8 transitions
    assign ns_S8 = (state[8]) ? ((in) ? 10'b0000000010 : 10'b0000000001) : 10'b0;
    // If in=1 -> S1; else S0

    // S9 transitions
    assign ns_S9 = (state[9]) ? ((in) ? 10'b0000000010 : 10'b0000000001) : 10'b0;
    // If in=1 -> S1; else S0

    // Combine all possible next states from active states
    assign next_state = ns_S0 | ns_S1 | ns_S2 | ns_S3 | ns_S4 | ns_S5 | ns_S6 | ns_S7 | ns_S8 | ns_S9;

    // Outputs per problem spec: only states with outputs set bits contribute
    assign out1 = |(state & 10'b1100000000); // out1=1 if state[8] or state[9] active
    assign out2 = |(state & 10'b1000001000); // out2=1 if state[7] or state[9] active

endmodule