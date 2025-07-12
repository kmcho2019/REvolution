module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 DFFs with individual reset values corresponding to 0x34 (00110100)
FDRE #(.INIT(1'b0)) dff0 (.C(~clk), .R(reset), .CE(1'b1), .D(d[0]), .Q(q[0]));  // Bit 0 = 0
FDRE #(.INIT(1'b0)) dff1 (.C(~clk), .R(reset), .CE(1'b1), .D(d[1]), .Q(q[1]));  // Bit 1 = 0
FDRE #(.INIT(1'b1)) dff2 (.C(~clk), .R(reset), .CE(1'b1), .D(d[2]), .Q(q[2]));  // Bit 2 = 1
FDRE #(.INIT(1'b1)) dff3 (.C(~clk), .R(reset), .CE(1'b1), .D(d[3]), .Q(q[3]));  // Bit 3 = 0
FDRE #(.INIT(1'b0)) dff4 (.C(~clk), .R(reset), .CE(1'b1), .D(d[4]), .Q(q[4]));  // Bit 4 = 1
FDRE #(.INIT(1'b1)) dff5 (.C(~clk), .R(reset), .CE(1'b1), .D(d[5]), .Q(q[5]));  // Bit 5 = 0
FDRE #(.INIT(1'b0)) dff6 (.C(~clk), .R(reset), .CE(1'b1), .D(d[6]), .Q(q[6]));  // Bit 6 = 0
FDRE #(.INIT(1'b0)) dff7 (.C(~clk), .R(reset), .CE(1'b1), .D(d[7]), .Q(q[7]));  // Bit 7 = 0

endmodule