module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    always @(*) begin
        next_state = 10'b0; // Initialize next_state to zero
        out1 = 1'b0; // Initialize out1 to zero
        out2 = 1'b0; // Initialize out2 to zero

        case ({in, state})
            // S0
            10'b0_0000000000: begin next_state[0] = 1'b1; end
            10'b1_0000000000: begin next_state[1] = 1'b1; end

            // S1
            10'b0_0000000001: begin next_state[0] = 1'b1; end
            10'b1_0000000001: begin next_state[2] = 1'b1; end

            // S2
            10'b0_0000000010: begin next_state[0] = 1'b1; end
            10'b1_0000000010: begin next_state[3] = 1'b1; end

            // S3
            10'b0_0000000100: begin next_state[0] = 1'b1; end
            10'b1_0000000100: begin next_state[4] = 1'b1; end

            // S4
            10'b0_0000001000: begin next_state[0] = 1'b1; end
            10'b1_0000001000: begin next_state[5] = 1'b1; end

            // S5
            10'b0_0000010000: begin next_state[8] = 1'b1; end
            10'b1_0000010000: begin next_state[6] = 1'b1; end

            // S6
            10'b0_0000100000: begin next_state[9] = 1'b1; end
            10'b1_0000100000: begin next_state[7] = 1'b1; end

            // S7
            10'b0_0001000000: begin next_state[0] = 1'b1; out2 = 1'b1; end
            10'b1_0001000000: begin next_state[7] = 1'b1; out2 = 1'b1; end

            // S8
            10'b0_0010000000: begin next_state[0] = 1'b1; out1 = 1'b1; end
            10'b1_0010000000: begin next_state[1] = 1'b1; out1 = 1'b1; end

            // S9
            10'b0_0100000000: begin next_state[0] = 1'b1; out1 = 1'b1; out2 = 1'b1; end
            10'b1_0100000000: begin next_state[1] = 1'b1; out1 = 1'b1; out2 = 1'b1; end

            default: begin next_state[0] = 1'b1; end
        endcase
    end

endmodule