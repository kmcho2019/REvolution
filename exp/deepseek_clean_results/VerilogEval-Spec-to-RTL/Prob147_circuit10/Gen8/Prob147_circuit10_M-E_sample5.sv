module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    if (a & ~state_reg) begin
        state_reg <= ~state_reg;  // Toggle when a=1 and state was 0
    end
    else if (b & state_reg) begin
        state_reg <= 0;           // Reset when b=1 and state was 1
    end
    // Otherwise maintain state
end

assign q = (state_reg ^ b) & ~(a & b);  // XOR except when both inputs are 1
assign state = state_reg;

endmodule