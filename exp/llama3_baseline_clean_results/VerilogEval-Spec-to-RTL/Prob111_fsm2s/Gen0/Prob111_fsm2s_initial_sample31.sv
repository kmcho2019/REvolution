module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg state; // Current state (0 for OFF, 1 for ON)

always_ff @(posedge clk) begin
    if (reset) begin // Synchronous reset
        state <= 0; // Reset to OFF state
        out <= 0; // Output is 0 in OFF state
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin // Transition to ON state
                    state <= 1;
                    out <= 1; // Output is 1 in ON state
                end else begin // Stay in OFF state
                    state <= 0;
                    out <= 0; // Output is 0 in OFF state
                end
            end
            1: begin // ON state
                if (k) begin // Transition to OFF state
                    state <= 0;
                    out <= 0; // Output is 0 in OFF state
                end else begin // Stay in ON state
                    state <= 1;
                    out <= 1; // Output is 1 in ON state
                end
            end
            default: begin // Invalid state (should not happen)
                state <= 0; // Reset to OFF state
                out <= 0; // Output is 0 in OFF state
            end
        endcase
    end
end

endmodule