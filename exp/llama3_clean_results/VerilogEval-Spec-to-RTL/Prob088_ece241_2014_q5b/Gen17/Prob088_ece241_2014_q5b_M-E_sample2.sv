module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // Internal state of the flip-flop

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A (assuming A is represented by 0)
    end else begin
        state <= ~state; // Toggle state based on input x and current state
    end
end

always @(*) begin
    z = state ^ x; // Generate 'z' based on current state and input 'x'
end

endmodule