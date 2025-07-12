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

    always @(state or in) begin
        next_state_reg = 10'b0;  // Initialize next_state to all zeros
        out1_reg = 1'b0;
        out2_reg = 1'b0;

        // Check all possible current states
        for (int i = 0; i <= 9; i++) begin
            if (state[i]) begin  // Check if the current state is active
                case (i)
                    0: begin  // S0
                        if (~in) begin
                            next_state_reg[0] = 1'b1;
                        end else begin
                            next_state_reg[1] = 1'b1;
                        end
                    end
                    1: begin  // S1
                        if (~in) begin
                            next_state_reg[0] = 1'b1;
                        end else begin
                            next_state_reg[2] = 1'b1;
                        end
                    end
                    2: begin  // S2
                        if (~in) begin
                            next_state_reg[0] = 1'b1;
                        end else begin
                            next_state_reg[3] = 1'b1;
                        end
                    end
                    3: begin  // S3
                        if (~in) begin
                            next_state_reg[0] = 1'b1;
                        end else begin
                            next_state_reg[4] = 1'b1;
                        end
                    end
                    4: begin  // S4
                        if (~in) begin
                            next_state_reg[0] = 1'b1;
                        end else begin
                            next_state_reg[5] = 1'b1;
                        end
                    end
                    5: begin  // S5
                        if (~in) begin
                            next_state_reg[8] = 1'b1;
                        end else begin
                            next_state_reg[6] = 1'b1;
                        end
                    end
                    6: begin  // S6
                        if (~in) begin
                            next_state_reg[9] = 1'b1;
                        end else begin
                            next_state_reg[7] = 1'b1;
                        end
                    end
                    7: begin  // S7
                        if (~in) begin
                            next_state_reg[0] = 1'b1;
                        end else begin
                            next_state_reg[7] = 1'b1;
                            out1_reg = 1'b0;
                            out2_reg = 1'b1;
                        end
                    end
                    8: begin  // S8
                        if (~in) begin
                            next_state_reg[0] = 1'b1;
                        end else begin
                            next_state_reg[1] = 1'b1;
                        end
                        out1_reg = 1'b1;
                        out2_reg = 1'b0;
                    end
                    9: begin  // S9
                        if (~in) begin
                            next_state_reg[0] = 1'b1;
                        end else begin
                            next_state_reg[1] = 1'b1;
                        end
                        out1_reg = 1'b1;
                        out2_reg = 1'b1;
                    end
                endcase
            end
        end

        next_state = next_state_reg;
        out1 = out1_reg;
        out2 = out2_reg;
    end

endmodule