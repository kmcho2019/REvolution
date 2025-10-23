module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

    // Instantiate 8 D flip-flops for each bit
    DFF dff0 (.clk(clk), .d(d[0]), .q(q[0]));
    DFF dff1 (.clk(clk), .d(d[1]), .q(q[1]));
    DFF dff2 (.clk(clk), .d(d[2]), .q(q[2]));
    DFF dff3 (.clk(clk), .d(d[3]), .q(q[3]));
    DFF dff4 (.clk(clk), .d(d[4]), .q(q[4]));
    DFF dff5 (.clk(clk), .d(d[5]), .q(q[5]));
    DFF dff6 (.clk(clk), .d(d[6]), .q(q[6]));
    DFF dff7 (.clk(clk), .d(d[7]), .q(q[7]));

endmodule