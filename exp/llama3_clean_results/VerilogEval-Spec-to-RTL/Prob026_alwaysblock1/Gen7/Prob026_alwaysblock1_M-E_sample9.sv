module TopModule #(
    parameter OUTPUT_SELECTION = 0 // 0: assign, 1: always block
)(
    input  a,
    input  b,
    input  select_output,
    output out_assign,
    output out_alwaysblock,
    output out_selected
);

assign out_assign = a & b;

reg out_alwaysblock_reg;
always @(*) begin
    out_alwaysblock_reg = a & b;
end
assign out_alwaysblock = out_alwaysblock_reg;

assign out_selected = (select_output == 0)? out_assign : out_alwaysblock;

endmodule