module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
        z <= 1'b0; // Reset z to 0
    end else begin
        if(!state && x) begin // Transition from A to B
            state <= 1'b1;
            z <= 1'b1; // Set z to 1 when transitioning to B
        end else if(state) begin // Stay in B
            state <= 1'b1;
            z <= ~x; // Set z based on x when in B
        end else begin // Stay in A
            state <= 1'b0;
            z <= 1'b0; // Set z to 0 when in A
        end
    end
end

endmodule