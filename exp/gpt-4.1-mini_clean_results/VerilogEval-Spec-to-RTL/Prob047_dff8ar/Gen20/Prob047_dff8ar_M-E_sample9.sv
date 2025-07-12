// Single-bit D flip-flop with asynchronous active-high reset
module DFF_1bit (
    input  wire clk,
    input  wire areset,  // Asynchronous active-high reset
    input  wire d,
    output reg  q
);
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 1'b0;  // Reset output asynchronously to 0
        else
            q <= d;     // Capture input on rising clock edge
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    // Instantiate 8 individual 1-bit D flip-flops
    DFF_1bit dff0 (.clk(clk), .areset(areset), .d(d[0]), .q(q[0]));
    DFF_1bit dff1 (.clk(clk), .areset(areset), .d(d[1]), .q(q[1]));
    DFF_1bit dff2 (.clk(clk), .areset(areset), .d(d[2]), .q(q[2]));
    DFF_1bit dff3 (.clk(clk), .areset(areset), .d(d[3]), .q(q[3]));
    DFF_1bit dff4 (.clk(clk), .areset(areset), .d(d[4]), .q(q[4]));
    DFF_1bit dff5 (.clk(clk), .areset(areset), .d(d[5]), .q(q[5]));
    DFF_1bit dff6 (.clk(clk), .areset(areset), .d(d[6]), .q(q[6]));
    DFF_1bit dff7 (.clk(clk), .areset(areset), .d(d[7]), .q(q[7]));
endmodule