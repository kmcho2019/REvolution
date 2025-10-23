module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg state; // 0 for OFF, 1 for ON

always @(posedge clk or posedge reset) begin
    if (reset) begin // Active-high synchronous reset
        state <= 0; // Reset to OFF state
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin
                    state <= 1; // Transition to ON if j = 1
                end else begin
                    state <= 0; // Stay in OFF if j = 0
                end
            end
            1: begin // ON state
                if (k) begin
                    state <= 0; // Transition to OFF if k = 1
                end else begin
                    state <= 1; // Stay in ON if k = 0
                end
            end
            default: state <= 0; // Default to OFF state for any other condition
        endcase
    end
end

always @(*) begin
    case (state)
        0: out = 0; // Output is 0 when in OFF state
        1: out = 1; // Output is 1 when in ON state
        default: out = 0; // Default output to 0
    endcase
end

endmodule