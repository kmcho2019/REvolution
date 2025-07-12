module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg state; // 1-bit signal to represent the state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Asynchronously reset to state B
        out <= 1'b1; // Reset output to state B's output
    end else begin
        case(state)
            1'b0: begin
                if (in) begin
                    state <= 1'b0; // Stay in state A
                    out <= 1'b0; // Update output for state A
                end else begin
                    state <= 1'b1; // Transition to state B
                    out <= 1'b1; // Update output for state B
                end
            end
            1'b1: begin
                if (in) begin
                    state <= 1'b1; // Stay in state B
                    out <= 1'b1; // Update output for state B
                end else begin
                    state <= 1'b0; // Transition to state A
                    out <= 1'b0; // Update output for state A
                end
            end
        endcase
    end
end

endmodule