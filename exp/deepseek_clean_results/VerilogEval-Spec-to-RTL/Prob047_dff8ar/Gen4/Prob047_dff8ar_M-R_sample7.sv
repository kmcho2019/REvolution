module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 individual D flip-flops
dff dff0 (.clk(clk), .areset(areset), .d(d[0]), .q(q[0]));
dff dff1 (.clk(clk), .areset(areset), .d(d[1]), .q(q[1]));
dff dff2 (.clk(clk), .areset(areset), .d(d[2]), .q(q[2]));
dff dff3 (.clk(clk), .areset(areset), .d(d[3]), .q(q[3]));
dff dff4 (.clk(clk), .areset(areset), .d(d[4]), .q(q[4]));
dff dff5 (.clk(clk), .areset(areset), .d(d[5]), .q(q[5]));
dff dff6 (.clk(clk), .areset(areset), .d(d[6]), .q(q[6]));
dff dff7 (.clk(clk), .areset(areset), .d(d[7]), .q(q[7]));

endmodule

// Basic D flip-flop with async reset
module dff (
    input clk,
    input areset,
    input d,
    output reg q
);
always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 1'b0;
    else
        q <= d;
end
endmodule