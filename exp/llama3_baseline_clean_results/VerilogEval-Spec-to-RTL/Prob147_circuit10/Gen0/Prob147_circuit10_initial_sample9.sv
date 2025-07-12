module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @(posedge clk) begin
    state_reg <= (a == 0 && b == 0 && state_reg == 0) || (a == 1 && b == 1 && state_reg == 0) || state_reg;
end

assign q = (b == 1 && state_reg == 0) || (a == 1 && b == 0 && state_reg == 1) || (a == 0 && b == 0 && state_reg == 1);

endmodule