module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    assign next_state[0] = zero_in & (
          state[0] | state[1] | state[2] | state[3] | state[4] 
        | state[7] | state[8] | state[9]
    );

    assign next_state[1] = one_in & (state[0] | state[8] | state[9]);
    assign next_state[2] = one_in & state[1];
    assign next_state[3] = one_in & state[2];
    assign next_state[4] = one_in & state[3];
    assign next_state[5] = one_in & state[4];
    assign next_state[6] = one_in & state[5];
    assign next_state[7] = one_in & (state[6] | state[7]);
    assign next_state[8] = zero_in & state[5];
    assign next_state[9] = zero_in & state[6];

    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule