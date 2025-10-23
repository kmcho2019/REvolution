module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;

initial state_reg = 0;

always @(posedge clk) begin
    state_reg <= b ? a : state_reg;
end

assign q = b ? ~state_reg : state_reg;
assign state = state_reg;

endmodule