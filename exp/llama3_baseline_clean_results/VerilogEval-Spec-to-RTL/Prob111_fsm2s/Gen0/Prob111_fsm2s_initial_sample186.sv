module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg state; // 0: OFF, 1: ON

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to OFF state
    end else begin
        case (state)
            0: state <= j ? 1 : 0; // Transition from OFF based on j
            1: state <= k ? 0 : 1; // Transition from ON based on k
            default: state <= 0; // Default to OFF if state is invalid
        endcase
    end
end

always @(state) begin
    case (state)
        0: out <= 0; // Output when in OFF state
        1: out <= 1; // Output when in ON state
        default: out <= 0; // Default output if state is invalid
    endcase
end

endmodule