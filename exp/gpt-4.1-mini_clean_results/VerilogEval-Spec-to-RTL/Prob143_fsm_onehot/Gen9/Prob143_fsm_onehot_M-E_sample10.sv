module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Intermediate next state signals per state based on input
    wire [9:0] next_from_S0;
    wire [9:0] next_from_S1;
    wire [9:0] next_from_S2;
    wire [9:0] next_from_S3;
    wire [9:0] next_from_S4;
    wire [9:0] next_from_S5;
    wire [9:0] next_from_S6;
    wire [9:0] next_from_S7;
    wire [9:0] next_from_S8;
    wire [9:0] next_from_S9;

    // Define transitions for each state using one-hot style next state assignment
    assign next_from_S0 = (in == 1'b0) ? 10'b0000000001 : 10'b0000000010; // S0->S0 or S1
    assign next_from_S1 = (in == 1'b0) ? 10'b0000000001 : 10'b0000000100; // S1->S0 or S2
    assign next_from_S2 = (in == 1'b0) ? 10'b0000000001 : 10'b0000001000; // S2->S0 or S3
    assign next_from_S3 = (in == 1'b0) ? 10'b0000000001 : 10'b0000010000; // S3->S0 or S4
    assign next_from_S4 = (in == 1'b0) ? 10'b0000000001 : 10'b0000100000; // S4->S0 or S5
    assign next_from_S5 = (in == 1'b0) ? 10'b0001000000 : 10'b0010000000; // S5->S8 or S6
    assign next_from_S6 = (in == 1'b0) ? 10'b0100000000 : 10'b1000000000; // S6->S9 or S7
    assign next_from_S7 = (in == 1'b0) ? 10'b0000000001 : 10'b1000000000; // S7->S0 or S7
    assign next_from_S8 = (in == 1'b0) ? 10'b0000000001 : 10'b0000000010; // S8->S0 or S1
    assign next_from_S9 = (in == 1'b0) ? 10'b0000000001 : 10'b0000000010; // S9->S0 or S1

    // Combine contributions from all active current states weighted by their active bit
    // Using bitwise AND and OR reduces complexity
    assign next_state =
           ({10{state[0]}} & next_from_S0) |
           ({10{state[1]}} & next_from_S1) |
           ({10{state[2]}} & next_from_S2) |
           ({10{state[3]}} & next_from_S3) |
           ({10{state[4]}} & next_from_S4) |
           ({10{state[5]}} & next_from_S5) |
           ({10{state[6]}} & next_from_S6) |
           ({10{state[7]}} & next_from_S7) |
           ({10{state[8]}} & next_from_S8) |
           ({10{state[9]}} & next_from_S9);

    // Outputs depend on current states:
    // out1 = 1 if any of state 8 or 9 active
    assign out1 = state[8] | state[9];

    // out2 = 1 if any of state 7 or 9 active
    assign out2 = state[7] | state[9];

endmodule