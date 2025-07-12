module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// Define state encoding explicitly for clarity
reg state; // 1'b0: State A, 1'b1: State B

always @(*) begin
    // Output z logic remains the same, as it's already minimized
    if(state) begin // State B
        z = ~x;
    end else begin // State A
        z = x;
    end
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Asynchronous reset to state A (1'b0)
        state <= 1'b0;
    end else begin
        // Transition logic remains the same for simplicity and efficiency
        state <= state | x; // Transition to B if x is 1, stay in B
    end
end

endmodule