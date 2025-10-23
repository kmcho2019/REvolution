module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Reset to state A
        state <= 1'b0;
    end else if (~state && x) begin
        // Transition to B if x=1 and in state A
        state <= 1'b1;
    end
end

always @(*) begin
    // Simplified logic for z
    z = (state ^ x);
end

endmodule