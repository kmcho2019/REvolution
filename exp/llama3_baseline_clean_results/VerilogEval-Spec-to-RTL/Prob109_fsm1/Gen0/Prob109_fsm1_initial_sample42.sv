module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg state;  // 0 for state A, 1 for state B

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1;  // Reset to state B
        out <= 1'b1;    // Output is 1 in state B
    end else begin
        case (state)
            1'b0: begin
                if (in) begin
                    state <= 1'b0;  // Stay in state A
                    out <= 1'b0;    // Output is 0 in state A
                end else begin
                    state <= 1'b1;  // Move to state B
                    out <= 1'b1;    // Output is 1 in state B
                end
            end
            1'b1: begin
                if (in) begin
                    state <= 1'b1;  // Stay in state B
                    out <= 1'b1;    // Output is 1 in state B
                end else begin
                    state <= 1'b0;  // Move to state A
                    out <= 1'b0;    // Output is 0 in state A
                end
            end
            default: begin
                state <= 1'b1;  // Default state is B
                out <= 1'b1;    // Default output is 1
            end
        endcase
    end
end

endmodule