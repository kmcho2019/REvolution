module TopModule(
    input clk,
    input d,
    output reg q
);

reg pos_edge_q, neg_edge_q;

always @(posedge clk) pos_edge_q <= d;
always @(negedge clk) neg_edge_q <= d;

assign q = clk ? pos_edge_q : neg_edge_q;

endmodule