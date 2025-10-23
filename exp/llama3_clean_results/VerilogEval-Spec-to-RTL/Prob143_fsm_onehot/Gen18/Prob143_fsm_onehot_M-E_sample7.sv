module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    // Define the lookup table (LUT) as a 2D array
    parameter [9:0][1:0] lut_out = {
        10'b0000000001, // S0
        10'b0000000010, // S1
        10'b0000000010, // S2
        10'b0000000010, // S3
        10'b0000000010, // S4
        10'b0000100000, // S5
        10'b0000010000, // S6
        10'b0000000001, // S7
        10'b1000000000, // S8
        10'b1000000000  // S9
    };

    parameter [9:0][1:0] lut_ns = {
        10'b0000000001, // S0
        10'b0000000010, // S1
        10'b0000000010, // S2
        10'b0000000010, // S3
        10'b0000000010, // S4
        10'b0000100000, // S5
        10'b0000010000, // S6
        10'b0000000001, // S7
        10'b1000000000, // S8
        10'b1000000000  // S9
    };

    // Use a case statement to index into the LUT based on the current state and input
    always @(*) begin
        next_state = 10'b0; // Initialize next_state to zero
        out1 = 1'b0; // Initialize out1 to zero
        out2 = 1'b0; // Initialize out2 to zero

        for (int i = 0; i < 10; i++) begin
            if (state[i]) begin // Check each state individually
                case (i)
                    0: begin
                        next_state = (in) ? lut_ns[1] : lut_ns[0];
                        out1 = (in) ? lut_out[1][0] : lut_out[0][0];
                        out2 = (in) ? lut_out[1][1] : lut_out[0][1];
                    end
                    1: begin
                        next_state = (in) ? lut_ns[2] : lut_ns[0];
                        out1 = (in) ? lut_out[2][0] : lut_out[0][0];
                        out2 = (in) ? lut_out[2][1] : lut_out[0][1];
                    end
                    2: begin
                        next_state = (in) ? lut_ns[3] : lut_ns[0];
                        out1 = (in) ? lut_out[3][0] : lut_out[0][0];
                        out2 = (in) ? lut_out[3][1] : lut_out[0][1];
                    end
                    3: begin
                        next_state = (in) ? lut_ns[4] : lut_ns[0];
                        out1 = (in) ? lut_out[4][0] : lut_out[0][0];
                        out2 = (in) ? lut_out[4][1] : lut_out[0][1];
                    end
                    4: begin
                        next_state = (in) ? lut_ns[5] : lut_ns[0];
                        out1 = (in) ? lut_out[5][0] : lut_out[0][0];
                        out2 = (in) ? lut_out[5][1] : lut_out[0][1];
                    end
                    5: begin
                        next_state = (in) ? lut_ns[6] : lut_ns[8];
                        out1 = (in) ? lut_out[6][0] : lut_out[8][0];
                        out2 = (in) ? lut_out[6][1] : lut_out[8][1];
                    end
                    6: begin
                        next_state = (in) ? lut_ns[7] : lut_ns[9];
                        out1 = (in) ? lut_out[7][0] : lut_out[9][0];
                        out2 = (in) ? lut_out[7][1] : lut_out[9][1];
                    end
                    7: begin
                        next_state = (in) ? lut_ns[7] : lut_ns[0];
                        out1 = (in) ? lut_out[7][0] : lut_out[0][0];
                        out2 = (in) ? lut_out[7][1] : lut_out[0][1];
                    end
                    8: begin
                        next_state = (in) ? lut_ns[1] : lut_ns[0];
                        out1 = (in) ? lut_out[1][0] : lut_out[0][0];
                        out2 = (in) ? lut_out[1][1] : lut_out[0][1];
                    end
                    9: begin
                        next_state = (in) ? lut_ns[1] : lut_ns[0];
                        out1 = (in) ? lut_out[1][0] : lut_out[0][0];
                        out2 = (in) ? lut_out[1][1] : lut_out[0][1];
                    end
                    default: next_state = lut_ns[0]; // Default state
                endcase
            end
        end
    end

endmodule