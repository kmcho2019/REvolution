module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

reg state; // Using binary encoding for states (0 for OFF, 1 for ON)
reg next_state;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 0; // Reset to OFF state
        out <= 0; // Reset output to 0
    end else begin
        state <= next_state;
        // Only update out when state changes
        if (state != next_state) begin
            out <= next_state; // Update out based on next_state
        end
    end
end

always @* begin
    case (state)
        0: begin // OFF state
            if (j) begin
                next_state = 1; // Transition to ON state
            end else begin
                next_state = 0; // Stay in OFF state
            end
        end
        1: begin // ON state
            if (k) begin
                next_state = 0; // Transition to OFF state
            end else begin
                next_state = 1; // Stay in ON state
            end
        end
        default: begin
            next_state = 0; // Default to OFF state
        end
    endcase
end

endmodule