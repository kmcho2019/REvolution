module DFF_neg (
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

// Instantiate 8 DFFs with their respective reset values from 0x34 (00110100)
DFF_neg dff7 (.clk(clk), .reset(reset), .d(d[7]), .reset_val(1'b0), .q(q[7]));
DFF_neg dff6 (.clk(clk), .reset(reset), .d(d[6]), .reset_val(1'b0), .q(q[6]));
DFF_neg dff5 (.clk(clk), .reset(reset), .d(d[5]), .reset_val(1'b1), .q(q[5]));
DFF_neg dff4 (.clk(clk), .reset(reset), .d(d[4]), .reset_val(1'b1), .q(q[4]));
DFF_neg dff3 (.clk(clk), .reset(reset), .d(d[3]), .reset_val(1'b0), .q(q[3]));
DFF_neg dff2 (.clk(clk), .reset(reset), .d(d[2]), .reset_val(1'b1), .q(q[2]));
DFF_neg dff1 (.clk(clk), .reset(reset), .d(d[1]), .reset_val(1'b0), .q(q[1]));
DFF_neg dff0 (.clk(clk), .reset(reset), .d(d[0]), .reset_val(1'b0), .q(q[0]));

endmodule