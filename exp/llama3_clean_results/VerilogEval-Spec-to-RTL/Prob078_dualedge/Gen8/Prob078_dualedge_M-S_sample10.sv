module TopModule(
    input clk,
    input d,
    output reg q
);

reg pos_q, neg_q;

always @(posedge clk) pos_q <= d;
always @(negedge clk) neg_q <= d;

assign q = clk? pos_q : neg_q;

endmodule