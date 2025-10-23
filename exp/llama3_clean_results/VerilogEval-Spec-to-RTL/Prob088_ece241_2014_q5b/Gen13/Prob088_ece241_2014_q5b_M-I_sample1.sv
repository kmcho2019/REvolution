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
    end else begin
        if (state == 1'b1 && x == 1'b1) begin
            state <= 1'b0; // Transition from A to B
        end else if (state == 1'b0) begin
            state <= 1'b0; // Stay in B
        end else begin
            state <= 1'b1; // Stay in A if not transitioning to B
        end
    end
end

always @(*) begin
    if (state == 1'b1) begin
        z = x; // When in state A, z follows x
    end else begin
        z = ~x; // When in state B, z is inverse of x
    end
end

endmodule