module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    if (a ^ b)         // Toggle when a and b differ
        state_reg <= ~state_reg;
end

assign q = (state_reg & ~b) | (~state_reg & a);
assign state = state_reg;

endmodule