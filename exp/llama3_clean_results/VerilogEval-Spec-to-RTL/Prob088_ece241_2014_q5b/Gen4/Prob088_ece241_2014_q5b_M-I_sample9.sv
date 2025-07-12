module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A

// Simplified combinational logic for output z
always @(*) begin
    if (state) begin
        z = ~x; // In state B, z is the inverse of x
    end else begin
        z = x; // In state A, z follows x
    end
end

// Optimized state transitions
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        if (!state && x) begin
            state <= 1'b1; // Transition from A to B when x is 1
        end else begin
            state <= state; // Stay in current state otherwise
        end
    end
end

endmodule