module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (0) and state B (1)

assign z = (state)? ~x : x; // Direct assignment for 'z'

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        // Simplified state transition logic
        state <= (state == 1'b0 && x == 1'b1) ? 1'b1 : 1'b0;
    end
end

endmodule