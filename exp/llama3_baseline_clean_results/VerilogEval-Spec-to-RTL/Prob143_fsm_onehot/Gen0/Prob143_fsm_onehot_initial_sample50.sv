module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to 0
    assign next_state = {
        // S9
        (state[9] && in) ? 1'b1 : 1'b0,
        // S8
        (state[8] && in) ? 1'b1 : 1'b0,
        // S7
        (state[7] && in) ? 1'b1 : 1'b0,
        // S6
        (state[6] && in) ? 1'b1 : 1'b0,
        // S5
        (state[5] && in) ? 1'b1 : 1'b0,
        // S4
        (state[4] && in) ? 1'b1 : 1'b0,
        // S3
        (state[3] && in) ? 1'b1 : 1'b0,
        // S2
        (state[2] && in) ? 1'b1 : 1'b0,
        // S1
        (state[1] && in) ? 1'b1 : 1'b0,
        // S0
        (state[0] && in) ? 1'b1 : 1'b0
    } | {
        // S9
        (state[9] && ~in) ? 1'b1 : 1'b0,
        // S8
        (state[8] && ~in) ? 1'b1 : 1'b0,
        // S7
        (state[7] && ~in) ? 1'b1 : 1'b0,
        // S6
        (state[6] && ~in) ? 1'b1 : 1'b0,
        // S5
        (state[5] && ~in) ? 1'b1 : 1'b0,
        // S4
        (state[4] && ~in) ? 1'b1 : 1'b0,
        // S3
        (state[3] && ~in) ? 1'b1 : 1'b0,
        // S2
        (state[2] && ~in) ? 1'b1 : 1'b0,
        // S1
        (state[1] && ~in) ? 1'b1 : 1'b0,
        // S0
        (state[0] && ~in) ? 1'b1 : 1'b0
    };

    // Determine next_state based on current state and input
    always @(*) begin
        casez ({state, in})
            // S0
            10'b1???????0: next_state[0] = 1'b1;
            10'b1???????1: next_state[1] = 1'b1;

            // S1
            10'b01??????0: next_state[0] = 1'b1;
            10'b01??????1: next_state[2] = 1'b1;

            // S2
            10'b001?????0: next_state[0] = 1'b1;
            10'b001?????1: next_state[3] = 1'b1;

            // S3
            10'b0001????0: next_state[0] = 1'b1;
            10'b0001????1: next_state[4] = 1'b1;

            // S4
            10'b00001???0: next_state[0] = 1'b1;
            10'b00001???1: next_state[5] = 1'b1;

            // S5
            10'b000001??0: next_state[8] = 1'b1;
            10'b000001??1: next_state[6] = 1'b1;

            // S6
            10'b0000001?0: next_state[9] = 1'b1;
            10'b0000001?1: next_state[7] = 1'b1;

            // S7
            10'b00000001: next_state[7] = 1'b1;
            10'b00000000: next_state[0] = 1'b1;

            // S8
            10'b0000000001: next_state[0] = 1'b1;
            10'b0000000001: next_state[1] = 1'b1;

            // S9
            10'b1000000000: next_state[0] = 1'b1;
            10'b1000000000: next_state[1] = 1'b1;
        endcase
    end

    // Generate outputs out1 and out2
    assign out1 = (state[7] || state[8] || state[9]);
    assign out2 = (state[7] || state[9]);

endmodule