module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Define a 2D array to store the pre-computed next states and output values
    reg [9:0] lut_next_state [1024];
    reg [1:0] lut_outputs [1024];

    // Initialize the LUT with pre-computed values
    initial begin
        for (int i = 0; i < 1024; i++) begin
            // Iterate over all possible input states
            for (int j = 0; j < 10; j++) begin
                // Check if the jth bit is set in the current state
                if (i >> j & 1'b1) begin
                    // Compute the next state and output values based on the current state and input
                    case (j)
                        0: if (!in) lut_next_state[i][0] = 1'b1; else lut_next_state[i][1] = 1'b1;
                        1: if (!in) lut_next_state[i][0] = 1'b1; else lut_next_state[i][2] = 1'b1;
                        2: if (!in) lut_next_state[i][0] = 1'b1; else lut_next_state[i][3] = 1'b1;
                        3: if (!in) lut_next_state[i][0] = 1'b1; else lut_next_state[i][4] = 1'b1;
                        4: if (!in) lut_next_state[i][0] = 1'b1; else lut_next_state[i][5] = 1'b1;
                        5: if (!in) lut_next_state[i][8] = 1'b1; else lut_next_state[i][6] = 1'b1;
                        6: if (!in) lut_next_state[i][9] = 1'b1; else lut_next_state[i][7] = 1'b1;
                        7: begin
                            if (!in) lut_next_state[i][0] = 1'b1; else lut_next_state[i][7] = 1'b1;
                            lut_outputs[i][1] = 1'b1;
                        end
                        8: begin
                            if (!in) lut_next_state[i][0] = 1'b1; else lut_next_state[i][1] = 1'b1;
                            lut_outputs[i][0] = 1'b1;
                        end
                        9: begin
                            if (!in) lut_next_state[i][0] = 1'b1; else lut_next_state[i][1] = 1'b1;
                            lut_outputs[i][0] = 1'b1;
                            lut_outputs[i][1] = 1'b1;
                        end
                    endcase
                end
            end
        end
    end

    // Use the LUT to determine the next state and output values
    always @(*) begin
        next_state = lut_next_state[state];
        out1 = lut_outputs[state][0];
        out2 = lut_outputs[state][1];
    end

endmodule