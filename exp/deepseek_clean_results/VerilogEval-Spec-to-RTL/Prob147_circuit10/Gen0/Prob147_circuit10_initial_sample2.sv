module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;

always @(posedge clk) begin
    if (a & b)
        state_reg <= 1'b1;
    else if (~a & ~b)
        state_reg <= 1'b0;
    // Otherwise maintain current state
end

assign q = state_reg ^ b;
assign state = state_reg;

endmodule