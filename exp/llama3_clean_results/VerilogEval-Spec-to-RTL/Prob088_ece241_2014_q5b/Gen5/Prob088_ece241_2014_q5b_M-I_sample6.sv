module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// Define state encoding explicitly for clarity
reg state; // 1'b0: State A, 1'b1: State B

always @(*) begin
    // Output z logic is simplified to reduce depth and improve timing
    z = state ? ~x : x;
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Asynchronous reset to state A (1'b0)
        state <= 1'b0;
    end else begin
        // Transition logic is kept simple to avoid introducing additional delays
        state <= state | x; // Transition to B if x is 1, stay in B
    end
end

endmodule