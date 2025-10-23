module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // State of the T-FF

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to 0
    end else if(x) begin
        state <= ~state; // Toggle state when x is 1
    end
end

always @(*) begin
    z = state ^ x; // Output 'z' based on state and 'x'
end

endmodule