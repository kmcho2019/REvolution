module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

reg current_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 0;  // Reset to state B
    end else begin
        case (current_state)
            0: begin  // State B
                if (!in) begin
                    current_state <= 1;  // Transition to state A
                end else begin
                    current_state <= 0;  // Stay in state B
                end
            end
            1: begin  // State A
                if (!in) begin
                    current_state <= 0;  // Transition to state B
                end else begin
                    current_state <= 1;  // Stay in state A
                end
            end
            default: current_state <= 0;
        endcase
    end
end

always @(*) begin
    case (current_state)
        0: out = 1;  // Output for state B
        1: out = 0;  // Output for state A
        default: out = 0;
    endcase
end

endmodule