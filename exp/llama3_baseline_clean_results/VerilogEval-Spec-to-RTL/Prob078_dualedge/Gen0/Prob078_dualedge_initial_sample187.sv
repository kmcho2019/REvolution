module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos, q_neg;

always @(posedge clk)
    q_pos <= d;

always @(negedge clk)
    q_neg <= d;

always @(*)
    q = (clk == 1'b1) ? q_pos : q_neg;

endmodule