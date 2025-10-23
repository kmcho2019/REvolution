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

    always @(*) begin
        next_state_reg = 10'b0; // Initialize next_state to zero
        out1_reg = 1'b0; // Initialize out1 to zero
        out2_reg = 1'b0; // Initialize out2 to zero

        case (1'b1) // Use a case statement to handle each state
            state[7]: begin // S7
                if (!in) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[7] = 1'b1;
                end
                out2_reg = 1'b1;
            end
            state[8]: begin // S8
                if (!in) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[1] = 1'b1;
                end
                out1_reg = 1'b1;
            end
            state[9]: begin // S9
                if (!in) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[1] = 1'b1;
                end
                out1_reg = 1'b1;
                out2_reg = 1'b1;
            end
            default: begin // Other states
                if (state[0]) begin // S0
                    if (!in) begin
                        next_state_reg[0] = 1'b1;
                    end else begin
                        next_state_reg[1] = 1'b1;
                    end
                end else if (state[1]) begin // S1
                    if (!in) begin
                        next_state_reg[0] = 1'b1;
                    end else begin
                        next_state_reg[2] = 1'b1;
                    end
                end else if (state[2]) begin // S2
                    if (!in) begin
                        next_state_reg[0] = 1'b1;
                    end else begin
                        next_state_reg[3] = 1'b1;
                    end
                end else if (state[3]) begin // S3
                    if (!in) begin
                        next_state_reg[0] = 1'b1;
                    end else begin
                        next_state_reg[4] = 1'b1;
                    end
                end else if (state[4]) begin // S4
                    if (!in) begin
                        next_state_reg[0] = 1'b1;
                    end else begin
                        next_state_reg[5] = 1'b1;
                    end
                end else if (state[5]) begin // S5
                    if (!in) begin
                        next_state_reg[8] = 1'b1;
                    end else begin
                        next_state_reg[6] = 1'b1;
                    end
                end else if (state[6]) begin // S6
                    if (!in) begin
                        next_state_reg[9] = 1'b1;
                    end else begin
                        next_state_reg[7] = 1'b1;
                    end
                end
            end
        endcase
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule