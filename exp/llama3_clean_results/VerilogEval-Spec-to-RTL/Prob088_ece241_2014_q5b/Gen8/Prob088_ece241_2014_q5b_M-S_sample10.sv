module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (0) and state B (1)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
        z <= 1'b0; // Initialize z to 0 on reset
    end else begin
        case(state)
            1'b0: begin
                state <= x? 1'b1 : 1'b0; // Transition from A to B or stay in A
                z <= x; // Update z based on x when in state A
            end
            1'b1: begin
                state <= 1'b1; // Stay in B
                z <= ~x; // Update z based on x when in state B
            end
        endcase
    end
end

endmodule