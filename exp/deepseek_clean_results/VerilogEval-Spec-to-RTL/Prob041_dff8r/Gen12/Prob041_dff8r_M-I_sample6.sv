module DFF (
    input clk,
    input reset,
    input d,
    output reg q
);
    always @(posedge clk)
        q <= reset ? 1'b0 : d;
endmodule

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);
    // Buffer tree for reset signal
    wire reset_buf1, reset_buf2;
    buf b1(reset_buf1, reset);
    buf b2(reset_buf2, reset_buf1);

    // Individual DFF instantiations
    DFF dff0 (.clk(clk), .reset(reset_buf2), .d(d[0]), .q(q[0]));
    DFF dff1 (.clk(clk), .reset(reset_buf2), .d(d[1]), .q(q[1]));
    DFF dff2 (.clk(clk), .reset(reset_buf2), .d(d[2]), .q(q[2]));
    DFF dff3 (.clk(clk), .reset(reset_buf2), .d(d[3]), .q(q[3]));
    DFF dff4 (.clk(clk), .reset(reset_buf2), .d(d[4]), .q(q[4]));
    DFF dff5 (.clk(clk), .reset(reset_buf2), .d(d[5]), .q(q[5]));
    DFF dff6 (.clk(clk), .reset(reset_buf2), .d(d[6]), .q(q[6]));
    DFF dff7 (.clk(clk), .reset(reset_buf2), .d(d[7]), .q(q[7]));
endmodule