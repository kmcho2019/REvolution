module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Explicit next state assignments for each active current state and input
    assign next_state =
        ({10{state[0]}} & (in ? 10'b0000000010 : 10'b0000000001)) | // S0 -> S1 or S0
        ({10{state[1]}} & (in ? 10'b0000000100 : 10'b0000000001)) | // S1 -> S2 or S0
        ({10{state[2]}} & (in ? 10'b0000001000 : 10'b0000000001)) | // S2 -> S3 or S0
        ({10{state[3]}} & (in ? 10'b0000010000 : 10'b0000000001)) | // S3 -> S4 or S0
        ({10{state[4]}} & (in ? 10'b0000100000 : 10'b0000000001)) | // S4 -> S5 or S0
        ({10{state[5]}} & (in ? 10'b0001000000 : 10'b0000010000)) | // S5 -> S6 or S8
        ({10{state[6]}} & (in ? 10'b0010000000 : 10'b0100000000)) | // S6 -> S7 or S9
        ({10{state[7]}} & (in ? 10'b0010000000 : 10'b0000000001)) | // S7 -> S7 or S0
        ({10{state[8]}} & (in ? 10'b0000000010 : 10'b0000000001)) | // S8 -> S1 or S0
        ({10{state[9]}} & (in ? 10'b0000000010 : 10'b0000000001));  // S9 -> S1 or S0

    // Outputs: out1 = 1 if state S8 or S9 active; out2 = 1 if state S7 or S9 active
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule