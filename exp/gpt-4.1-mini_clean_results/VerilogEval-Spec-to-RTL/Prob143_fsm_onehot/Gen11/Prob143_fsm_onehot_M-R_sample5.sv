module TopModule(
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output reg       out1,
    output reg       out2
);

    always @* begin
        // Default all next_state bits to zero
        next_state = 10'b0;

        // next_state[0]: transitions to S0 on input=0 from multiple states
        next_state[0] = (
            (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]) & (~in)
        );

        // next_state[1] on input=1 from S0, S8, S9
        next_state[1] = (state[0] | state[8] | state[9]) & in;

        // next_state[2] on input=1 from S1
        next_state[2] = state[1] & in;

        // next_state[3] on input=1 from S2
        next_state[3] = state[2] & in;

        // next_state[4] on input=1 from S3
        next_state[4] = state[3] & in;

        // next_state[5] on input=1 from S4
        next_state[5] = state[4] & in;

        // next_state[6] on input=1 from S5
        next_state[6] = state[5] & in;

        // next_state[7] on input=1 from S6 and S7
        next_state[7] = (state[6] | state[7]) & in;

        // next_state[8] on input=0 from S5
        next_state[8] = state[5] & (~in);

        // next_state[9] on input=0 from S6
        next_state[9] = state[6] & (~in);

        // Output logic based on current state
        out1 = |(state & ((1 << 8) | (1 << 9)));  // S8 or S9 active
        out2 = |(state & ((1 << 7) | (1 << 9)));  // S7 or S9 active
    end

endmodule