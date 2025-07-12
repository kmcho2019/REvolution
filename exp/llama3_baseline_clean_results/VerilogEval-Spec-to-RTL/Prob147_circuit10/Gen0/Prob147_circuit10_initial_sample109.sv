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
    state_reg <= (!a && b) || (state_reg && a);
end

assign q = (a && !b) || (state_reg && b);

endmodule