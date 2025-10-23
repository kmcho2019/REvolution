module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    if (a & b) state_reg <= 1'b1;      // Set when both inputs high
    else if (~a & ~b) state_reg <= 1'b0; // Reset when both inputs low
    // Otherwise state remains unchanged
end

assign q = a ^ b ^ state_reg;  // XOR when state=0, XNOR when state=1
assign state = state_reg;

endmodule