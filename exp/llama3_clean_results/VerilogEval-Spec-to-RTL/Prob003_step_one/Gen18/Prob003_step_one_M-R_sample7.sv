module TopModule(
    output one
);
reg one_reg;
always @(*) begin
    one_reg = 1'b1;
end
assign one = one_reg;
endmodule