module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // 1-bit state variable (0 = OFF, 1 = ON)

always @(posedge clk) begin
    if (reset) begin // Active-high synchronous reset
        state <= 0; // Reset to state OFF
    end else begin
        case (state)
            0: begin // State OFF
                if (j) begin
                    state <= 1; // Transition to state ON
                end
            end
            1: begin // State ON
                if (k) begin
                    state <= 0; // Transition to state OFF
                end
            end
            default: state <= 0;
        endcase
    end
end

always @(*) begin
    case (state)
        0: out = 0; // Output for state OFF
        1: out = 1; // Output for state ON
        default: out = 0;
    endcase
end

endmodule