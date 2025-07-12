module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;  // internal flip-flop
assign state = state_reg;

always @(posedge clk) begin
    state_reg <= (!a && !b && !state_reg) || (a && !b && state_reg) || (a && b && state_reg) || (!a && b && state_reg);
end

assign q = (b && !state_reg) || (!a && !b && state_reg);

endmodule