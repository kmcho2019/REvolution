module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 individual DFFs
DFF dff0 (.clk(clk), .reset(areset), .d(d[0]), .q(q[0]));
DFF dff1 (.clk(clk), .reset(areset), .d(d[1]), .q(q[1]));
DFF dff2 (.clk(clk), .reset(areset), .d(d[2]), .q(q[2]));
DFF dff3 (.clk(clk), .reset(areset), .d(d[3]), .q(q[3]));
DFF dff4 (.clk(clk), .reset(areset), .d(d[4]), .q(q[4]));
DFF dff5 (.clk(clk), .reset(areset), .d(d[5]), .q(q[5]));
DFF dff6 (.clk(clk), .reset(areset), .d(d[6]), .q(q[6]));
DFF dff7 (.clk(clk), .reset(areset), .d(d[7]), .q(q[7]));

endmodule

// D flip-flop with asynchronous reset
module DFF (
    input clk,
    input reset,
    input d,
    output reg q
);
always @(posedge clk or posedge reset) begin
    if (reset) q <= 1'b0;
    else q <= d;
end
endmodule