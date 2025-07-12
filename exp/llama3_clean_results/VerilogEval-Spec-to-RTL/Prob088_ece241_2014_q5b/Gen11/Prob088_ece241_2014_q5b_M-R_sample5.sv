module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for states A and B

assign z = (state ^ x); // Directly assign z based on state and x

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Reset to state A
        state <= 1'b0;
    end else begin
        // Transition to B if in A and x=1, stay in B otherwise
        if(state == 1'b0 && x == 1'b1) begin
            state <= 1'b1;
        end else begin
            state <= state;
        end
    end
end

endmodule