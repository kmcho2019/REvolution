module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // State variable (0 to 7)

// Output signals are registered for a complete cycle
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        // Reset state to behave as though previous input were 0
        state <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: begin // Initial state or after a 0
                if (in) state <= 1;
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            1, 2, 3, 4: begin // 1 to 4 consecutive 1s
                if (in) state <= state + 1;
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            5: begin // 5 consecutive 1s, look for discard
                if (in) state <= 6; // Moving towards flag or error
                else state <= 0; // Reset on seeing a 0 after 5 ones
                disc_reg <= 1; // Signal discard for this cycle
                flag_reg <= 0;
                err_reg <= 0;
            end
            6: begin // Potential flag or error
                if (in) begin // More than 6 consecutive 1s, potential error
                    state <= 7; // Move to error state
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 1; // Error condition
                end else begin // Exactly 6 ones followed by a 0, flag condition
                    state <= 0; // Reset after flag
                    disc_reg <= 0;
                    flag_reg <= 1; // Signal flag for this cycle
                    err_reg <= 0;
                end
            end
            7: begin // Error state, stay here until a 0 is seen
                if (in) state <= 7; // Stay in error state
                else state <= 0; // Reset on seeing a 0
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 1; // Keep error signal high
            end
            default: begin
                state <= 0;
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