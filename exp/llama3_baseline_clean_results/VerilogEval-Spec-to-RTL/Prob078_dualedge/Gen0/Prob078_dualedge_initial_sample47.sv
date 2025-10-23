module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_pos, q_neg, q_out;
wire clk_neg = ~clk;

always @(posedge clk)
    q_pos <= d;

always @(posedge clk_neg)
    q_neg <= d;

assign q = q_pos | q_neg;

endmodule