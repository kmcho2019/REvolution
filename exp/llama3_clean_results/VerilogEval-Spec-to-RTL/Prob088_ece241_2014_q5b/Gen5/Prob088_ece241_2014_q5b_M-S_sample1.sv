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
        z <= 1'b0;
    end else begin
        if(state) begin // State B
            z <= 1'b1;
            state <= 1'b1; // Stay in B
        end else begin // State A
            z <= 1'b0;
            if(x) begin
                state <= 1'b1; // Transition from A to B
            end else begin
                state <= 1'b0; // Stay in A
            end
        end
    end
end

endmodule