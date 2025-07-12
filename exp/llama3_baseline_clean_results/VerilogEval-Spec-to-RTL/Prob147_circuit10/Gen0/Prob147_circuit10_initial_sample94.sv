module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;
assign q = (state_reg == 1'b0) ? b : ~b;

always @(posedge clk)
begin
    state_reg <= ~a ? state_reg : ~state_reg;
end

endmodule