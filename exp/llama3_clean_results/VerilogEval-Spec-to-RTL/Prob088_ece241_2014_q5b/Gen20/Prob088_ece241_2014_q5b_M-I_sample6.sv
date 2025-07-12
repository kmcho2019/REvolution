module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (1) and state B (0)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Reset to state A
    end else begin
        if (state == 1'b1 && x == 1'b1) begin
            state <= 1'b0; // Transition from A to B
        end else if (state == 1'b0 && x == 1'b0) begin
            state <= 1'b0; // Stay in B
        end else begin
            state <= state; // Stay in current state
        end
    end
end

always @(*) begin
    z = (state)? x : ~x; // Simplified logic for 'z'
end

endmodule