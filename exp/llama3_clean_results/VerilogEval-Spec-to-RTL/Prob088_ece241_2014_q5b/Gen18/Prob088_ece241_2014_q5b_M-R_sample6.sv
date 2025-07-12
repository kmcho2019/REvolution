module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (1) and state B (0)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Reset to state A
        z <= 1'b0; // Reset z to 0
    end else begin
        case(state)
            1'b1: begin
                state <= x ? 1'b0 : 1'b1; // Transition from A to B or stay in A
                z <= x; // Generate 'z' based on current state and 'x'
            end
            1'b0: begin
                state <= 1'b0; // Stay in B
                z <= ~x; // Generate 'z' for state B
            end
        endcase
    end
end

endmodule