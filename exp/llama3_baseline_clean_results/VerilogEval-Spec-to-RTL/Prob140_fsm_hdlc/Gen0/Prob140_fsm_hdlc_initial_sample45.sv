module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // State register
reg disc_reg, flag_reg, err_reg; // Output registers

// Define states
parameter S0 = 3'b000, S5 = 3'b001, S6 = 3'b010, S7 = 3'b011;

always @(posedge clk) begin
    if (reset) begin // Reset to initial state
        state <= S0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            S0: begin
                if (in) begin // Seen one '1'
                    state <= S0; // Stay in S0 until 5 consecutive '1's are seen
                end else begin
                    state <= S0; // Stay in S0
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            S5: begin
                if (in) begin // Seen 6 consecutive '1's
                    state <= S6;
                end else begin // Seen '0' after 5 '1's, discard bit
                    state <= S0;
                    disc_reg <= 1; // Discard bit
                end
                flag_reg <= 0;
                err_reg <= 0;
            end
            S6: begin
                if (in) begin // Error, seen 7 consecutive '1's
                    state <= S7;
                end else begin // Flag seen, reset to S0
                    state <= S0;
                    flag_reg <= 1; // Signal flag
                end
                disc_reg <= 0;
                err_reg <= 0;
            end
            S7: begin
                if (~in) begin // Reset to S0 on seeing '0'
                    state <= S0;
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 1; // Signal error
            end
            default: begin // Default case for invalid states
                state <= S0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule