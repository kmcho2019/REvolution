module DFF_async_reset (
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

module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output [7:0] q
);
    // Instantiate 8 separate single-bit DFFs
    DFF_async_reset dff0 (.clk(clk), .areset(areset), .d(d[0]), .q(q[0]));
    DFF_async_reset dff1 (.clk(clk), .areset(areset), .d(d[1]), .q(q[1]));
    DFF_async_reset dff2 (.clk(clk), .areset(areset), .d(d[2]), .q(q[2]));
    DFF_async_reset dff3 (.clk(clk), .areset(areset), .d(d[3]), .q(q[3]));
    DFF_async_reset dff4 (.clk(clk), .areset(areset), .d(d[4]), .q(q[4]));
    DFF_async_reset dff5 (.clk(clk), .areset(areset), .d(d[5]), .q(q[5]));
    DFF_async_reset dff6 (.clk(clk), .areset(areset), .d(d[6]), .q(q[6]));
    DFF_async_reset dff7 (.clk(clk), .areset(areset), .d(d[7]), .q(q[7]));
endmodule