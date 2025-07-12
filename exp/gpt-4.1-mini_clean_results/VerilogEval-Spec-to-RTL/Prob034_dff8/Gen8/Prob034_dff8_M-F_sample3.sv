module DFF (
    input clk,
    input rst,       // asynchronous active-high reset
    input d,
    output reg q
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        rst,   // asynchronous reset input added
    input  [7:0] d,
    output [7:0] q
);
    // Instantiate eight DFFs with reset support
    DFF dff0 (.clk(clk), .rst(rst), .d(d[0]), .q(q[0]));
    DFF dff1 (.clk(clk), .rst(rst), .d(d[1]), .q(q[1]));
    DFF dff2 (.clk(clk), .rst(rst), .d(d[2]), .q(q[2]));
    DFF dff3 (.clk(clk), .rst(rst), .d(d[3]), .q(q[3]));
    DFF dff4 (.clk(clk), .rst(rst), .d(d[4]), .q(q[4]));
    DFF dff5 (.clk(clk), .rst(rst), .d(d[5]), .q(q[5]));
    DFF dff6 (.clk(clk), .rst(rst), .d(d[6]), .q(q[6]));
    DFF dff7 (.clk(clk), .rst(rst), .d(d[7]), .q(q[7]));
endmodule