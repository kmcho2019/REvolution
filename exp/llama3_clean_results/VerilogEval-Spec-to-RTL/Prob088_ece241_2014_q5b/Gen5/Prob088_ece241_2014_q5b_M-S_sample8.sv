module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (1'b0) and state B (1'b1)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
        z <= 1'b0; // Reset z
    end else begin
        state <= (x &&!state) || state; // Move to B when x=1 from A, stay in B otherwise
        z <= (state)? ~x : x; // 'z' is the inverse of 'x' in state B, otherwise it follows 'x'
    end
end

endmodule