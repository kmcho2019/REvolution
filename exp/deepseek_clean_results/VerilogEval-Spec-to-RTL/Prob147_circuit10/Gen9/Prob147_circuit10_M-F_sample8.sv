module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    if ((~a & ~b) || (a & b & state_reg))
        state_reg <= 1;
    else
        state_reg <= 0;
end

assign q = (state_reg & ~b) | (a & b);
assign state = state_reg;

endmodule