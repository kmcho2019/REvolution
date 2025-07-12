module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg state; // State variable to represent the current state (0 - OFF, 1 - ON)

always @ (posedge clk) begin
    if (reset) begin // Active-high reset
        state <= 0; // Reset to OFF state
        out <= 0; // Output for OFF state
    end else begin
        case (state)
            0: begin // Current state is OFF
                if (j) begin
                    state <= 1; // Transition to ON state
                    out <= 1; // Output for ON state
                end else begin
                    state <= 0; // Stay in OFF state
                    out <= 0; // Output for OFF state
                end
            end
            1: begin // Current state is ON
                if (k) begin
                    state <= 0; // Transition to OFF state
                    out <= 0; // Output for OFF state
                end else begin
                    state <= 1; // Stay in ON state
                    out <= 1; // Output for ON state
                end
            end
            default: begin
                state <= 0; // Default to OFF state
                out <= 0; // Output for OFF state
            end
        endcase
    end
end

endmodule