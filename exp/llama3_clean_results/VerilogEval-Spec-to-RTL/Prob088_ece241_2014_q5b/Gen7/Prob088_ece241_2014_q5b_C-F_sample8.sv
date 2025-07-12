module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (1'b1) and state B (1'b0)

always @(*) begin
    z = state ? ~x : x; // Directly assign z based on state and x
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Reset to state A
    end else begin
        state <= ~state & x | state; // Transition to or stay in B if x is 1 or already in B
    end
end

endmodule