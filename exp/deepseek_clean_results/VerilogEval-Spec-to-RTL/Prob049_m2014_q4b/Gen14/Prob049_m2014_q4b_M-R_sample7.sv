module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

wire q_reg;
assign q_reg = ar ? 1'b0 : (posedge clk ? d : q_reg);
assign q = q_reg;

endmodule