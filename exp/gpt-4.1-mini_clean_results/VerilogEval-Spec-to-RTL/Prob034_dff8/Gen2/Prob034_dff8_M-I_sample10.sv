module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);
    wire [7:0] q_internal;

    DFF dff0 (.clk(clk), .d(d[0]), .q(q_internal[0]));
    DFF dff1 (.clk(clk), .d(d[1]), .q(q_internal[1]));
    DFF dff2 (.clk(clk), .d(d[2]), .q(q_internal[2]));
    DFF dff3 (.clk(clk), .d(d[3]), .q(q_internal[3]));
    DFF dff4 (.clk(clk), .d(d[4]), .q(q_internal[4]));
    DFF dff5 (.clk(clk), .d(d[5]), .q(q_internal[5]));
    DFF dff6 (.clk(clk), .d(d[6]), .q(q_internal[6]));
    DFF dff7 (.clk(clk), .d(d[7]), .q(q_internal[7]));

    assign q = q_internal;
endmodule