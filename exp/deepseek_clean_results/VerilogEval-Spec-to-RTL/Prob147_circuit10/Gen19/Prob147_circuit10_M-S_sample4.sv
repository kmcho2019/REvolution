module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    if (a & b)          // Set condition
        state_reg <= 1'b1;
    else if (~a & ~b)   // Reset condition
        state_reg <= 1'b0;
end

assign q = state_reg ? ~(a ^ b) : (a ^ b);
assign state = state_reg;

endmodule