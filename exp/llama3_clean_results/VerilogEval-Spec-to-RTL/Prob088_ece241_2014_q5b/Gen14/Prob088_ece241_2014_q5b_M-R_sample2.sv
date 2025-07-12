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
        z <= 1'b0; // Reset output z
    end else begin
        if(state == 1'b0) begin
            if(x) begin
                state <= 1'b1; // Transition from A to B
                z <= 1'b1; // Set z for state B
            end else begin
                state <= 1'b0; // Stay in A
                z <= 1'b0; // Set z for state A
            end
        end else begin // state == 1'b1
            state <= 1'b1; // Stay in B
            z <= ~x; // Invert x for state B
        end
    end
end

endmodule