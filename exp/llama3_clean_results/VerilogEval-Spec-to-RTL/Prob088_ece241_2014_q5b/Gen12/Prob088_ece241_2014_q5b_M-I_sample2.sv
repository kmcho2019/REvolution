module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
        z <= 1'b0; // Initialize z to 0 in reset state
    end else begin
        if (!state) begin // Currently in state A
            z <= x; // Output z is x in state A
            state <= x; // Transition to state B if x is 1
        end else begin // Currently in state B
            z <= ~x; // Output z is ~x in state B
            // No need to change state in state B, as it stays in B regardless of x
        end
    end
end

endmodule