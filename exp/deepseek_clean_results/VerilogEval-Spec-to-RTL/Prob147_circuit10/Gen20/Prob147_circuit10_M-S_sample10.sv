module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    if (a & b) state_reg <= 1'b1;
    else if (~a & ~b) state_reg <= 1'b0;
end

assign q = a ^ b ^ state_reg;
assign state = state_reg;

endmodule