module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Outputs are asserted in these states
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

    // Precompute common conditions for input=0 transitions leading to S0
    wire zero_input_return_s0 = ~in & (
          state[0] | state[1] | state[2] | state[3] | state[4]
        | state[7] | state[8] | state[9]
    );

    // Precompute next state bits dependent on input=1 transitions
    wire in_from_s0   = state[0] & in;
    wire in_from_s1   = state[1] & in;
    wire in_from_s2   = state[2] & in;
    wire in_from_s3   = state[3] & in;
    wire in_from_s4   = state[4] & in;
    wire in_from_s5   = state[5] & in;
    wire in_from_s6   = state[6] & in;
    wire in_from_s7   = state[7] & in;

    // Precompute input=0 transitions from states 5 and 6 (leading to S8 and S9)
    wire zero_from_s5 = state[5] & ~in;
    wire zero_from_s6 = state[6] & ~in;

    assign next_state[0] = zero_input_return_s0 | (state[7] & ~in);

    assign next_state[1] = in_from_s0 | (state[8] & in) | (state[9] & in);

    assign next_state[2] = in_from_s1;

    assign next_state[3] = in_from_s2;

    assign next_state[4] = in_from_s3;

    assign next_state[5] = in_from_s4;

    assign next_state[6] = in_from_s5;

    assign next_state[7] = in_from_s6 | in_from_s7;

    assign next_state[8] = zero_from_s5;

    assign next_state[9] = zero_from_s6;

endmodule