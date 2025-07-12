module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire in0 = ~in;
    wire in1 =  in;

    // Direct combinational next state logic from transitions:
    assign next_state[0] =
        (state[0] & in0) | (state[1] & in0) | (state[2] & in0) | (state[3] & in0) |
        (state[4] & in0) | (state[7] & in0) | (state[8] & in0) | (state[9] & in0);

    assign next_state[1] =
        (state[0] & in1) | (state[8] & in1) | (state[9] & in1);

    assign next_state[2] = state[1] & in1;
    assign next_state[3] = state[2] & in1;
    assign next_state[4] = state[3] & in1;
    assign next_state[5] = state[4] & in1;

    assign next_state[6] = state[5] & in1;
    assign next_state[7] = (state[6] & in1) | (state[7] & in1);

    assign next_state[8] = state[5] & in0;
    assign next_state[9] = state[6] & in0;

    // Output logic as OR of specified states
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule