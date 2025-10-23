module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // next_state[0] transitions to S0 on input 0 from multiple states
    assign next_state[0] = ( (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]) & zero_in );

    // next_state[1] transitions to S1 on input 1 from S0, S8, S9
    assign next_state[1] = (state[0] | state[8] | state[9]) & one_in;

    // next_state[2..7] transitions on input 1 from corresponding states
    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;
    assign next_state[6] = state[5] & one_in;
    assign next_state[7] = (state[6] | state[7]) & one_in;

    // next_state[8] and [9] transitions to S8 and S9 respectively on input 0 from S5 and S6
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    // Outputs
    assign out1 = |(state & 10'b1100000000); // S8 or S9
    assign out2 = |(state & 10'b0100001000); // S7 or S9

endmodule