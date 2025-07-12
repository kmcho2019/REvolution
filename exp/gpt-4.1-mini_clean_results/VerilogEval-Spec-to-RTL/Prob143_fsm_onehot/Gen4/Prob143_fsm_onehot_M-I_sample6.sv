module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Intermediate signals for next_state to reduce large OR fan-in

    wire zero_in = ~in;
    wire one_in  =  in;

    // States that transition to S0 on input 0
    wire to_S0_on_0_lower = state[0] | state[1] | state[2] | state[3] | state[4];
    wire to_S0_on_0_upper = state[7] | state[8] | state[9];
    assign next_state[0] = (to_S0_on_0_lower & zero_in) | (to_S0_on_0_upper & zero_in);

    // next_state[1] from S0, S8, S9 on input 1
    assign next_state[1] = (state[0] | state[8] | state[9]) & one_in;

    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;

    // next_state[6,7,8,9] transitions
    assign next_state[6] = state[5] & one_in;
    assign next_state[7] = (state[6] & one_in) | (state[7] & one_in);
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    // Outputs from states with specified output bits
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule