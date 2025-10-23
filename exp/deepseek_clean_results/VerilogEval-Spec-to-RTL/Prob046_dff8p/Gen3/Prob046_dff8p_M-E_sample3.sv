module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 DFFs with individual reset values
DFF dff7 (.clk(clk), .reset(reset), .d(d[7]), .q(q[7]), .reset_val(1'b0));
DFF dff6 (.clk(clk), .reset(reset), .d(d[6]), .q(q[6]), .reset_val(1'b0));
DFF dff5 (.clk(clk), .reset(reset), .d(d[5]), .q(q[5]), .reset_val(1'b1));
DFF dff4 (.clk(clk), .reset(reset), .d(d[4]), .q(q[4]), .reset_val(1'b1));
DFF dff3 (.clk(clk), .reset(reset), .d(d[3]), .q(q[3]), .reset_val(1'b0));
DFF dff2 (.clk(clk), .reset(reset), .d(d[2]), .q(q[2]), .reset_val(1'b1));
DFF dff1 (.clk(clk), .reset(reset), .d(d[1]), .q(q[1]), .reset_val(1'b0));
DFF dff0 (.clk(clk), .reset(reset), .d(d[0]), .q(q[0]), .reset_val(1'b0));

endmodule

// Single-bit D flip-flop module with configurable reset value
module DFF (
    input clk,
    input reset,
    input d,
    input reset_val,
    output reg q
);

always @(negedge clk) begin
    if (reset) begin
        q <= reset_val;
    end else begin
        q <= d;
    end
end

endmodule