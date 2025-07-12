module TopModule (
    input clk,
    input d,
    output q
);

wire q_pos = clk ? d : q_pos;
wire q_neg = ~clk ? d : q_neg;
assign q = clk ? q_pos : q_neg;

endmodule