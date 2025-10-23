module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // 0: OFF, 1: ON

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to OFF state
        out <= 0; // out = 0 in OFF state
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin
                    state <= 1; // Transition to ON state
                    out <= 1; // out = 1 in ON state
                end else begin
                    state <= 0; // Stay in OFF state
                    out <= 0; // out = 0 in OFF state
                end
            end
            1: begin // ON state
                if (k) begin
                    state <= 0; // Transition to OFF state
                    out <= 0; // out = 0 in OFF state
                end else begin
                    state <= 1; // Stay in ON state
                    out <= 1; // out = 1 in ON state
                end
            end
            default: state <= 0; // Default to OFF state
        endcase
    end
end

endmodule