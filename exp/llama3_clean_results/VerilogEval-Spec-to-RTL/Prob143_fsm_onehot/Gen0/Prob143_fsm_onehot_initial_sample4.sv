module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to zero
    assign next_state = 10'b0;

    // Generate next state based on current state and input signal
    always @(*) begin
        casez({state, in})
            // S0
            10'b1_xxxx_0: next_state[0] = 1'b1;
            10'b1_xxxx_1: next_state[1] = 1'b1;

            // S1
            10'b0_1xxx_0: next_state[0] = 1'b1;
            10'b0_1xxx_1: next_state[2] = 1'b1;

            // S2
            10'b0_01xx_0: next_state[0] = 1'b1;
            10'b0_01xx_1: next_state[3] = 1'b1;

            // S3
            10'b0_001x_0: next_state[0] = 1'b1;
            10'b0_001x_1: next_state[4] = 1'b1;

            // S4
            10'b0_0001_0: next_state[0] = 1'b1;
            10'b0_0001_1: next_state[5] = 1'b1;

            // S5
            10'b0_00001_0: next_state[8] = 1'b1;
            10'b0_00001_1: next_state[6] = 1'b1;

            // S6
            10'b0_000001_0: next_state[9] = 1'b1;
            10'b0_000001_1: next_state[7] = 1'b1;

            // S7
            10'b0_0000001_0: next_state[0] = 1'b1;
            10'b0_0000001_1: next_state[7] = 1'b1;

            // S8
            10'b0_00000001_0: next_state[0] = 1'b1;
            10'b0_00000001_1: next_state[1] = 1'b1;

            // S9
            10'b0_000000001_0: next_state[0] = 1'b1;
            10'b0_000000001_1: next_state[1] = 1'b1;

            default: next_state[0] = 1'b1;
        endcase
    end

    // Generate output signals based on current state
    assign out1 = (state[7] | state[9] | state[8]);
    assign out2 = state[7];

endmodule