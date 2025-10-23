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
        z <= 1'b0; // Reset output z
    end else begin
        if (!state) begin // State A
            z <= 1'b0; // Output z in state A
            if (x) begin
                state <= 1'b1; // Transition to state B
            end
        end else begin // State B
            z <= ~x; // Output z in state B
        end
    end
end

endmodule