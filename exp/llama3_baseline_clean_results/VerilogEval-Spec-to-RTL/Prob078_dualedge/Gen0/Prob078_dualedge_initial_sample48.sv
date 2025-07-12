module TopModule(
    input clk,
    input d,
    output q
);

reg q_pos;
reg q_neg;

always @(posedge clk)
    q_pos <= d;

always @(negedge clk)
    q_neg <= d;

assign q = q_pos | q_neg;

endmodule