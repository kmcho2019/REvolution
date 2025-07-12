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
        z <= 1'b0; // Reset output z to 0
    end else begin
        if(state) begin // State B
            state <= 1'b1; // Stay in B
            z <= 1'b1; // Output z is 1 in state B
        end else begin // State A
            if(x) begin // Transition from A to B
                state <= 1'b1;
                z <= 1'b1; // Output z is 1 when transitioning from A to B due to x=1
            end else begin // Stay in A
                state <= 1'b0;
                z <= 1'b0; // Output z is 0 in state A when x=0
            end
        end
    end
end

endmodule