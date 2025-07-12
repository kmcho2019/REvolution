module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Current state (0 for B, 1 for A)

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 0; // Reset to state B
        out <= 1; // Reset output to 1
    end else begin
        if (state == 0) begin // Currently in state B
            if (!in) begin
                state <= 1; // Move to state A
                out <= 0; // Set output to 0
            end else begin
                state <= 0; // Stay in state B
                out <= 1; // Keep output at 1
            end
        end else begin // Currently in state A
            if (!in) begin
                state <= 0; // Move to state B
                out <= 1; // Set output to 1
            end else begin
                state <= 1; // Stay in state A
                out <= 0; // Keep output at 0
            end
        end
    end
end

endmodule