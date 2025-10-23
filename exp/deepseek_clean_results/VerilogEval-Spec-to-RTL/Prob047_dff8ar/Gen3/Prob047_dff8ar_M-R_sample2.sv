module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 DFFs with async reset
DFF dff0 (.clk(clk), .areset(areset), .d(d[0]), .q(q[0]));
DFF dff1 (.clk(clk), .areset(areset), .d(d[1]), .q(q[1]));
DFF dff2 (.clk(clk), .areset(areset), .d(d[2]), .q(q[2]));
DFF dff3 (.clk(clk), .areset(areset), .d(d[3]), .q(q[3]));
DFF dff4 (.clk(clk), .areset(areset), .d(d[4]), .q(q[4]));
DFF dff5 (.clk(clk), .areset(areset), .d(d[5]), .q(q[5]));
DFF dff6 (.clk(clk), .areset(areset), .d(d[6]), .q(q[6]));
DFF dff7 (.clk(clk), .areset(areset), .d(d[7]), .q(q[7]));

endmodule

// D flip-flop with async reset module
module DFF (
    input clk,
    input areset,
    input d,
    output reg q
);
always @(posedge clk or posedge areset)
    if (areset) q <= 1'b0;
    else q <= d;
endmodule