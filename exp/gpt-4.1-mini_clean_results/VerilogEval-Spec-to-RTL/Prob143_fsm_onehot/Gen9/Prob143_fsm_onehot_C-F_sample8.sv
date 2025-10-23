module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Input complement signals to reduce repeated inversion
    wire zero_in = ~in;
    wire one_in  =  in;

    // Group states that transition to S0 on input=0 to reduce fan-in for next_state[0]
    wire to_S0_on_0_lower = state[0] | state[1] | state[2] | state[3] | state[4];
    wire to_S0_on_0_upper = state[7] | state[8] | state[9];
    assign next_state[0] = (to_S0_on_0_lower & zero_in) | (to_S0_on_0_upper & zero_in);

    // Other next_state bits assigned directly for clarity and minimal fan-in
    assign next_state[1] = (state[0] | state[8] | state[9]) & one_in;
    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;
    assign next_state[6] = state[5] & one_in;

    // next_state[7] transitions from S6 and S7 on input=1
    assign next_state[7] = (state[6] & one_in) | (state[7] & one_in);

    // next_state[8] and next_state[9] on input=0 transitions
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    // Outputs: out1 = 1 if state is S8 or S9; out2 = 1 if state is S7 or S9
    localparam [9:0] mask_out1 = (1 << 8) | (1 << 9);
    localparam [9:0] mask_out2 = (1 << 7) | (1 << 9);

    assign out1 = |(state & mask_out1);
    assign out2 = |(state & mask_out2);

endmodule