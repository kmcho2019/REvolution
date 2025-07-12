module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (0) and state B (1)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        if(state) begin // State B
            state <= 1'b1; // Stay in B
        end else begin // State A
            state <= x? 1'b1 : 1'b0; // Transition from A to B or stay in A
        end
    end
end

always @(*) begin
    z = (state)? ~x : x; // Simplified logic for 'z'
end

endmodule