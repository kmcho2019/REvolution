module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg state; // 0 for OFF, 1 for ON

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to OFF state
    end else begin
        case (state)
            0: begin // State OFF
                if (j) begin
                    state <= 1; // Transition to ON if j = 1
                end else begin
                    state <= 0; // Stay in OFF if j = 0
                end
            end
            1: begin // State ON
                if (k) begin
                    state <= 0; // Transition to OFF if k = 1
                end else begin
                    state <= 1; // Stay in ON if k = 0
                end
            end
            default: state <= 0; // Default to OFF state if state is invalid
        endcase
    end
end

always @(*) begin
    out = state; // Output reflects the current state
end

endmodule