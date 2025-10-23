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

        // Determine next state and output values based on current state and input
        case (1'b1) // Use a case statement to simplify the logic
            state[0]: begin // S0
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[1] = 1'b1;
                end
            end
            state[1]: begin // S1
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[2] = 1'b1;
                end
            end
            state[2]: begin // S2
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[3] = 1'b1;
                end
            end
            state[3]: begin // S3
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[4] = 1'b1;
                end
            end
            state[4]: begin // S4
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[5] = 1'b1;
                end
            end
            state[5]: begin // S5
                if (in == 1'b0) begin
                    next_state_reg[8] = 1'b1;
                end else begin
                    next_state_reg[6] = 1'b1;
                end
            end
            state[6]: begin // S6
                if (in == 1'b0) begin
                    next_state_reg[9] = 1'b1;
                end else begin
                    next_state_reg[7] = 1'b1;
                end
            end
            state[7]: begin // S7
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[7] = 1'b1;
                end
                out1_reg = 1'b0;
                out2_reg = 1'b1;
            end
            state[8]: begin // S8
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[1] = 1'b1;
                end
                out1_reg = 1'b1;
                out2_reg = 1'b0;
            end
            state[9]: begin // S9
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[1] = 1'b1;
                end
                out1_reg = 1'b1;
                out2_reg = 1'b1;
            end
            default: begin
                next_state_reg[0] = 1'b1; // Default to S0 if no match
            end
        endcase
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule