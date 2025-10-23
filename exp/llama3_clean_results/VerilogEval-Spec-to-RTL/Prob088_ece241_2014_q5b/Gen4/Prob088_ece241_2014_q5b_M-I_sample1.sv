module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A

always @(*) begin
    // Simplified logic for z to potentially reduce area and power
    z = (state ^ x);
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Reset to state A
        state <= 1'b0;
    end else begin
        // Transition to B if x=1 and stay in B
        // The condition is directly reflected, potentially reducing area
        state <= (state || (state == 1'b0 && x == 1'b1));
    end
end

endmodule