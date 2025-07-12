module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A

always @(*) begin
    // Directly assign output z based on the current state and input x
    z = (state)? ~x : x;
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Reset to state A
        state <= 1'b0;
    end else begin
        // Transition to B if x is 1, stay in B
        state <= (x)? 1'b1 : (state? 1'b1 : 1'b0);
    end
end

endmodule