module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (1'b0) and state B (1'b1)

always @(*) begin
    // Simplified combinational logic for output 'z'
    z = (state)? ~x : x;
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        // Directly encode next state logic for simplicity and potential timing improvement
        state <= (x &&!state) || state; // Move to B when x=1 from A, stay in B otherwise
    end
end

endmodule