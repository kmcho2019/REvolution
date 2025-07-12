module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg state; // 0 - OFF, 1 - ON

always @ (posedge clk) begin
    if (reset) begin // Active-high synchronous reset to state OFF
        state <= 0;
    end else begin
        case (state)
            0: begin // State OFF
                if (j) begin
                    state <= 1; // Transition to state ON
                end else begin
                    state <= 0; // Stay in state OFF
                end
            end
            1: begin // State ON
                if (k) begin
                    state <= 0; // Transition to state OFF
                end else begin
                    state <= 1; // Stay in state ON
                end
            end
            default: state <= 0; // Default to state OFF
        endcase
    end
end

always @ (*) begin
    case (state)
        0: out = 0; // State OFF: out = 0
        1: out = 1; // State ON: out = 1
        default: out = 0; // Default to out = 0
    endcase
end

endmodule