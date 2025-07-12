module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Combinational next_state computation:
    // For each possible next state Si, identify all current states Sj and inputs that lead there.

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : gen_next_state_logic
            // Initialize next_state[i] to zero
            wire next_i;

            // Compute next_state[i] by enumerating all state transitions leading to Si
            // This is a compact way using case inside generate is not allowed,
            // so we manually write conditions per next_state index.

            // Using an internal function for clarity:
            // Not possible inside generate, so explicit assign after generate.

        end
    endgenerate

    // Explicit combinational assignments:

    // next_state[0]: transitions to S0 happen from:
    // S0 (in=0), S1 (in=0), S2 (in=0), S3 (in=0), S4 (in=0),
    // S7 (in=0), S8 (in=0), S9 (in=0)
    assign next_state[0] =
           (state[0] & ~in) |
           (state[1] & ~in) |
           (state[2] & ~in) |
           (state[3] & ~in) |
           (state[4] & ~in) |
           (state[7] & ~in) |
           (state[8] & ~in) |
           (state[9] & ~in);

    // next_state[1]: from S0 (in=1), S8 (in=1), S9 (in=1)
    assign next_state[1] =
           (state[0] & in) |
           (state[8] & in) |
           (state[9] & in);

    // next_state[2]: from S1 (in=1)
    assign next_state[2] = state[1] & in;

    // next_state[3]: from S2 (in=1)
    assign next_state[3] = state[2] & in;

    // next_state[4]: from S3 (in=1)
    assign next_state[4] = state[3] & in;

    // next_state[5]: from S4 (in=1)
    assign next_state[5] = state[4] & in;

    // next_state[6]: from S5 (in=1)
    assign next_state[6] = state[5] & in;

    // next_state[7]: from S6 (in=1), S7 (in=1)
    assign next_state[7] = (state[6] & in) | (state[7] & in);

    // next_state[8]: from S5 (in=0)
    assign next_state[8] = state[5] & ~in;

    // next_state[9]: from S6 (in=0)
    assign next_state[9] = state[6] & ~in;

    // Outputs:
    // out1=1 if state is S8 or S9 (state[8] or state[9])
    assign out1 = state[8] | state[9];

    // out2=1 if state is S7 or S9
    assign out2 = state[7] | state[9];

endmodule