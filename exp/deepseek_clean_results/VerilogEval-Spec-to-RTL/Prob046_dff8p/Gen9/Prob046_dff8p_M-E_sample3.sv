module NegEdgeDFF (
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

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 DFFs with specific reset values to achieve 0x34
NegEdgeDFF dff7 (.clk(clk), .reset(reset), .d(d[7]), .reset_val(1'b0), .q(q[7]));
NegEdgeDFF dff6 (.clk(clk), .reset(reset), .d(d[6]), .reset_val(1'b0), .q(q[6]));
NegEdgeDFF dff5 (.clk(clk), .reset(reset), .d(d[5]), .reset_val(1'b1), .q(q[5]));
NegEdgeDFF dff4 (.clk(clk), .reset(reset), .d(d[4]), .reset_val(1'b1), .q(q[4]));
NegEdgeDFF dff3 (.clk(clk), .reset(reset), .d(d[3]), .reset_val(1'b0), .q(q[3]));
NegEdgeDFF dff2 (.clk(clk), .reset(reset), .d(d[2]), .reset_val(1'b1), .q(q[2]));
NegEdgeDFF dff1 (.clk(clk), .reset(reset), .d(d[1]), .reset_val(1'b0), .q(q[1]));
NegEdgeDFF dff0 (.clk(clk), .reset(reset), .d(d[0]), .reset_val(1'b0), .q(q[0]));

endmodule