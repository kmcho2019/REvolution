module TopModule (
    input clk,
    input d,
    output q
);

wire q_pos, q_neg;

assign q_pos = (clk && !$stable(clk)) ? d : q_pos;
assign q_neg = (!clk && !$stable(clk)) ? d : q_neg;
assign q = clk ? q_pos : q_neg;

endmodule