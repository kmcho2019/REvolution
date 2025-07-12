module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 D flip-flops with reset
DFF dff0 (.clk(clk), .d(d[0]), .q(q[0]), .reset(1'b0));
DFF dff1 (.clk(clk), .d(d[1]), .q(q[1]), .reset(1'b0));
DFF dff2 (.clk(clk), .d(d[2]), .q(q[2]), .reset(1'b0));
DFF dff3 (.clk(clk), .d(d[3]), .q(q[3]), .reset(1'b0));
DFF dff4 (.clk(clk), .d(d[4]), .q(q[4]), .reset(1'b0));
DFF dff5 (.clk(clk), .d(d[5]), .q(q[5]), .reset(1'b0));
DFF dff6 (.clk(clk), .d(d[6]), .q(q[6]), .reset(1'b0));
DFF dff7 (.clk(clk), .d(d[7]), .q(q[7]), .reset(1'b0));

endmodule

// D flip-flop primitive with asynchronous reset
module DFF (
    input clk,
    input d,
    input reset,
    output reg q
);
always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 1'b0;
    else
        q <= d;
end
endmodule