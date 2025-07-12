module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // State of the T flip-flop

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Asynchronous reset to state A (0)
        state <= 1'b0;
    end else begin
        // Toggle state when x is high
        state <= state ^ x;
    end
end

always @(*) begin
    // Generate z based on state and x
    z = state ^ x;
end

endmodule