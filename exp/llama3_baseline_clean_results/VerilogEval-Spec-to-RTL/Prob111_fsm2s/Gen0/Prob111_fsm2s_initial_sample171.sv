module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [0:0] current_state; // 1-bit register to store current state

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 0; // Reset to state OFF
    end else begin
        case (current_state)
            0: begin // State OFF
                if (j) begin
                    current_state <= 1; // Transition to state ON
                end else begin
                    current_state <= 0; // Stay in state OFF
                end
            end
            1: begin // State ON
                if (k) begin
                    current_state <= 0; // Transition to state OFF
                end else begin
                    current_state <= 1; // Stay in state ON
                end
            end
        endcase
    end
end

always @ (*) begin
    case (current_state)
        0: out <= 0; // State OFF, out = 0
        1: out <= 1; // State ON, out = 1
    endcase
end

endmodule