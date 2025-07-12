module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // 1-bit state: 0 for OFF, 1 for ON

always @(posedge clk) begin
    if (reset) begin // Active-high synchronous reset
        state <= 0; // Reset to OFF state
        out <= 0; // Set output to 0 when in OFF state
    end else begin
        case (state)
            0: begin // State OFF
                if (j) begin
                    state <= 1; // Transition to ON if j=1
                    out <= 1; // Set output to 1 when in ON state
                end else begin
                    state <= 0; // Stay in OFF if j=0
                    out <= 0; // Keep output at 0 when staying in OFF state
                end
            end
            1: begin // State ON
                if (k) begin
                    state <= 0; // Transition to OFF if k=1
                    out <= 0; // Set output to 0 when transitioning back to OFF state
                end else begin
                    state <= 1; // Stay in ON if k=0
                    out <= 1; // Keep output at 1 when staying in ON state
                end
            end
        endcase
    end
end

endmodule