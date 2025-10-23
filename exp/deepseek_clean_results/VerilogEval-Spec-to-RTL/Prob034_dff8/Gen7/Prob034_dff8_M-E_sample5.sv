module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Single-bit D flip-flop module
module DFF (
    input clk,
    input d,
    output reg q
);
always @(posedge clk) begin
    q <= d;
end
endmodule

// Instantiate 8 DFFs
DFG DFF0 (.clk(clk), .d(d[0]), .q(q[0]));
DFF DFF1 (.clk(clk), .d(d[1]), .q(q[1]));
DFF DFF2 (.clk(clk), .d(d[2]), .q(q[2]));
DFF DFF3 (.clk(clk), .d(d[3]), .q(q[3]));
DFF DFF4 (.clk(clk), .d(d[4]), .q(q[4]));
DFF DFF5 (.clk(clk), .d(d[5]), .q(q[5]));
DFF DFF6 (.clk(clk), .d(d[6]), .q(q[6]));
DFF DFF7 (.clk(clk), .d(d[7]), .q(q[7]));

endmodule