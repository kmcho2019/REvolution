module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A

assign z = (state) ? ~x : x; // Continuous assignment for output z

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        // Simplified state transition logic, using non-blocking assignment
        if (x && !state) begin
            state <= 1'b1; // Transition to state B
        end else if (!x && state) begin
            state <= 1'b1; // Remain in state B
        end else begin
            state <= state; // Either remain in A or in B based on previous state
        end
    end
end

endmodule