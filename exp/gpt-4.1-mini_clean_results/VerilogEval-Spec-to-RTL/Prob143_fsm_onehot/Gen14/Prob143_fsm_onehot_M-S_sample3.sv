module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    assign next_state[0] = (state[0] & zero_in) | (state[1] & zero_in) | (state[2] & zero_in) |
                           (state[3] & zero_in) | (state[4] & zero_in) | (state[7] & zero_in) |
                           (state[8] & zero_in) | (state[9] & zero_in);

    assign next_state[1] = (state[0] & one_in) | (state[8] & one_in) | (state[9] & one_in);
    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;
    assign next_state[6] = state[5] & one_in;
    assign next_state[7] = (state[6] & one_in) | (state[7] & one_in);
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    assign out1 = (state[8]) | (state[9]);
    assign out2 = (state[7]) | (state[9]);

endmodule