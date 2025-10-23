module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Next state when input = 0
    // From problem:
    // S0, S1, S2, S3, S4, S7, S8, S9 -> S0 (index 0)
    // S5 -> S8 (index 8)
    // S6 -> S9 (index 9)
    wire [9:0] next0 = 
        (state[0]  ? 10'b0000000001 : 10'b0) | // S0->S0
        (state[1]  ? 10'b0000000001 : 10'b0) | // S1->S0
        (state[2]  ? 10'b0000000001 : 10'b0) | // S2->S0
        (state[3]  ? 10'b0000000001 : 10'b0) | // S3->S0
        (state[4]  ? 10'b0000000001 : 10'b0) | // S4->S0
        (state[5]  ? 10'b0000000100 : 10'b0) | // S5->S8
        (state[6]  ? 10'b0000001000 : 10'b0) | // S6->S9
        (state[7]  ? 10'b0000000001 : 10'b0) | // S7->S0
        (state[8]  ? 10'b0000000001 : 10'b0) | // S8->S0
        (state[9]  ? 10'b0000000001 : 10'b0);  // S9->S0

    // Next state when input = 1
    // From problem:
    // S0->S1(1)
    // S1->S2(2)
    // S2->S3(3)
    // S3->S4(4)
    // S4->S5(5)
    // S5->S6(6)
    // S6->S7(7)
    // S7->S7(7)
    // S8->S1(1)
    // S9->S1(1)
    wire [9:0] next1 = 
        (state[0] ? 10'b0000000010 : 10'b0) | // S0->S1
        (state[1] ? 10'b0000000100 : 10'b0) | // S1->S2
        (state[2] ? 10'b0000001000 : 10'b0) | // S2->S3
        (state[3] ? 10'b0000010000 : 10'b0) | // S3->S4
        (state[4] ? 10'b0000100000 : 10'b0) | // S4->S5
        (state[5] ? 10'b0001000000 : 10'b0) | // S5->S6
        (state[6] ? 10'b0010000000 : 10'b0) | // S6->S7
        (state[7] ? 10'b0010000000 : 10'b0) | // S7->S7
        (state[8] ? 10'b0000000010 : 10'b0) | // S8->S1
        (state[9] ? 10'b0000000010 : 10'b0);  // S9->S1

    assign next_state = in ? next1 : next0;

    // Outputs:
    // out1 = S8 or S9 (bits 8,9)
    // out2 = S7 or S9 (bits 7,9)
    assign out1 = |(state & 10'b1100000000);
    assign out2 = |(state & 10'b1010000000);

endmodule