module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to zero
    assign next_state = 10'b0;

    // Initialize outputs to zero
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // Determine next state and outputs based on current state and input
    always @(*) begin
        casez ({state, in})
            // S0
            10'b1???????0: next_state[0] = 1'b1;
            10'b1???????1: next_state[1] = 1'b1;

            // S1
            10'b0 1??????0: next_state[0] = 1'b1;
            10'b0 1??????1: next_state[2] = 1'b1;

            // S2
            10'b0 0 1?????0: next_state[0] = 1'b1;
            10'b0 0 1?????1: next_state[3] = 1'b1;

            // S3
            10'b0 0 0 1????0: next_state[0] = 1'b1;
            10'b0 0 0 1????1: next_state[4] = 1'b1;

            // S4
            10'b0 0 0 0 1???0: next_state[0] = 1'b1;
            10'b0 0 0 0 1???1: next_state[5] = 1'b1;

            // S5
            10'b0 0 0 0 0 1??0: next_state[8] = 1'b1;
            10'b0 0 0 0 0 1??1: next_state[6] = 1'b1;

            // S6
            10'b0 0 0 0 0 0 1?0: next_state[9] = 1'b1;
            10'b0 0 0 0 0 0 1?1: next_state[7] = 1'b1;

            // S7
            10'b0 0 0 0 0 0 0 1 0: begin out1 = 1'b0; out2 = 1'b1; next_state[0] = 1'b1; end
            10'b0 0 0 0 0 0 0 1 1: begin out1 = 1'b0; out2 = 1'b1; next_state[7] = 1'b1; end

            // S8
            10'b0 0 0 0 0 0 0 0 1 0: begin out1 = 1'b1; out2 = 1'b0; next_state[0] = 1'b1; end
            10'b0 0 0 0 0 0 0 0 1 1: begin out1 = 1'b1; out2 = 1'b0; next_state[1] = 1'b1; end

            // S9
            10'b0 0 0 0 0 0 0 0 0 1 0: begin out1 = 1'b1; out2 = 1'b1; next_state[0] = 1'b1; end
            10'b0 0 0 0 0 0 0 0 0 1 1: begin out1 = 1'b1; out2 = 1'b1; next_state[1] = 1'b1; end

            default: next_state[0] = 1'b1;
        endcase
    end

endmodule