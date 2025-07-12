module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire in0 = ~in;
    wire in1 =  in;

    // Next state logic grouped by input condition for less redundant logic

    // For input = 0
    wire next_S0_from_in0 = 
           state[0] && in0
        || state[1] && in0
        || state[2] && in0
        || state[3] && in0
        || state[4] && in0
        || state[7] && in0
        || state[8] && in0
        || state[9] && in0;

    wire next_S8 = state[5] && in0;
    wire next_S9 = state[6] && in0;

    // For input = 1
    wire next_S1_from_in1 =
           state[0] && in1
        || state[8] && in1
        || state[9] && in1;

    wire next_S2 = state[1] && in1;
    wire next_S3 = state[2] && in1;
    wire next_S4 = state[3] && in1;
    wire next_S5 = state[4] && in1;
    wire next_S6 = state[5] && in1;
    wire next_S7 =
           state[6] && in1
        || state[7] && in1;

    // Assign next states
    assign next_state[0] = next_S0_from_in0;
    assign next_state[1] = next_S1_from_in1;
    assign next_state[2] = next_S2;
    assign next_state[3] = next_S3;
    assign next_state[4] = next_S4;
    assign next_state[5] = next_S5;
    assign next_state[6] = next_S6;
    assign next_state[7] = next_S7;
    assign next_state[8] = next_S8;
    assign next_state[9] = next_S9;

    // Outputs: 
    // out1 = 1 if in S8 or S9
    // out2 = 1 if in S7 or S9
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule