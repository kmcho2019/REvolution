module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @(posedge clk) begin
    if (a == 1'b0 && b == 1'b1) state_reg <= 1'b1;
    else if (a == 1'b0 && b == 1'b0 && state_reg == 1'b1) state_reg <= 1'b0;
    else if (a == 1'b1 && b == 1'b1 && state_reg == 1'b0) state_reg <= 1'b1;
    else state_reg <= state_reg;
end

assign q = (state_reg == 1'b1 && a == 1'b1) || (b == 1'b1 && a == 1'b0);

initial state_reg = 1'b0;

endmodule