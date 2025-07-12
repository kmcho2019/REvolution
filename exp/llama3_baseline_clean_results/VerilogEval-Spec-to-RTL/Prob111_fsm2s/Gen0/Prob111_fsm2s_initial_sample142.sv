module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg state; // OFF (0), ON (1)

always @(posedge clk) begin
    if (reset) begin // Active-high synchronous reset
        state <= 0; // Reset to OFF state
    end else begin
        case (state)
            0: state <= (j) ? 1 : 0; // OFF state transitions
            1: state <= (!k) ? 1 : 0; // ON state transitions
            default: state <= 0;
        endcase
    end
end

always @(state) begin
    case (state)
        0: out <= 0; // Output when in OFF state
        1: out <= 1; // Output when in ON state
        default: out <= 0;
    endcase
end

endmodule