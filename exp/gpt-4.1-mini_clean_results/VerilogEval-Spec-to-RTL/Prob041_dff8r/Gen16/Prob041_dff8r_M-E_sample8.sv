module DFF (
    input wire clk,
    input wire reset,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input wire clk,
    input wire reset,
    input wire [7:0] d,
    output wire [7:0] q
);
    DFF dff0 (.clk(clk), .reset(reset), .d(d[0]), .q(q[0]));
    DFF dff1 (.clk(clk), .reset(reset), .d(d[1]), .q(q[1]));
    DFF dff2 (.clk(clk), .reset(reset), .d(d[2]), .q(q[2]));
    DFF dff3 (.clk(clk), .reset(reset), .d(d[3]), .q(q[3]));
    DFF dff4 (.clk(clk), .reset(reset), .d(d[4]), .q(q[4]));
    DFF dff5 (.clk(clk), .reset(reset), .d(d[5]), .q(q[5]));
    DFF dff6 (.clk(clk), .reset(reset), .d(d[6]), .q(q[6]));
    DFF dff7 (.clk(clk), .reset(reset), .d(d[7]), .q(q[7]));
endmodule