module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    reg [9:0] next_state_reg;
    reg out1_reg;
    reg out2_reg;

    // Define the lookup tables for next state and output values
    reg [9:0] next_state_lut [10][2];
    reg [1:0] output_lut [10][2];

    // Initialize the lookup tables
    initial begin
        for (int i = 0; i < 10; i++) begin
            for (int j = 0; j < 2; j++) begin
                case (i)
                    0: begin
                        next_state_lut[i][j] = (j == 0) ? 10'b1 : 10'b10;
                        output_lut[i][j] = 2'b00;
                    end
                    1: begin
                        next_state_lut[i][j] = (j == 0) ? 10'b1 : 10'b100;
                        output_lut[i][j] = 2'b00;
                    end
                    2: begin
                        next_state_lut[i][j] = (j == 0) ? 10'b1 : 10'b1000;
                        output_lut[i][j] = 2'b00;
                    end
                    3: begin
                        next_state_lut[i][j] = (j == 0) ? 10'b1 : 10'b10000;
                        output_lut[i][j] = 2'b00;
                    end
                    4: begin
                        next_state_lut[i][j] = (j == 0) ? 10'b1 : 10'b100000;
                        output_lut[i][j] = 2'b00;
                    end
                    5: begin
                        next_state_lut[i][j] = (j == 0) ? 10'b100000000 : 10'b1000000;
                        output_lut[i][j] = 2'b00;
                    end
                    6: begin
                        next_state_lut[i][j] = (j == 0) ? 10'b1000000000 : 10'b10000000;
                        output_lut[i][j] = 2'b00;
                    end
                    7: begin
                        next_state_lut[i][j] = (j == 0) ? 10'b1 : 10'b10000000;
                        output_lut[i][j] = (j == 0) ? 2'b00 : 2'b01;
                    end
                    8: begin
                        next_state_lut[i][j] = (j == 0) ? 10'b1 : 10'b10;
                        output_lut[i][j] = (j == 0) ? 2'b10 : 2'b10;
                    end
                    9: begin
                        next_state_lut[i][j] = (j == 0) ? 10'b1 : 10'b10;
                        output_lut[i][j] = (j == 0) ? 2'b11 : 2'b11;
                    end
                    default: begin
                        next_state_lut[i][j] = 10'b1;
                        output_lut[i][j] = 2'b00;
                    end
                endcase
            end
        end
    end

    always @(*) begin
        next_state_reg = 10'b0; // Initialize next_state to zero
        out1_reg = 1'b0; // Initialize out1 to zero
        out2_reg = 1'b0; // Initialize out2 to zero

        for (int i = 9; i >= 0; i--) begin
            if (state[i]) begin // Check each state individually
                next_state_reg = next_state_lut[i][in];
                {out2_reg, out1_reg} = output_lut[i][in];
                break; // Priority encoder: highest priority state is selected
            end
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule