// Maintaining the existing solution as it is already optimized for the given requirements
// and PPA metrics do not indicate significant areas for improvement within the RTL code.

module ByteModule(
    input clk,
    input resetn,
    input byteena,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (~resetn) q <= 8'd0;
    else if (byteena) q <= d;
end

endmodule

module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

ByteModule upper_byte(
  .clk(clk),
  .resetn(resetn),
  .byteena(byteena[1]),
  .d(d[15:8]),
  .q(q[15:8])
);

ByteModule lower_byte(
  .clk(clk),
  .resetn(resetn),
  .byteena(byteena[0]),
  .d(d[7:0]),
  .q(q[7:0])
);

endmodule