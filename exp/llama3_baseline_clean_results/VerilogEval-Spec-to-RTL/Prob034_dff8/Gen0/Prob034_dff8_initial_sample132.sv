module DFF(d, clk, q);
  input d;
  input clk;
  output reg q;

  always @(posedge clk) begin
    q <= d;
  end
endmodule

module TopModule(clk, d, q);
  input clk;
  input [7:0] d;
  output [7:0] q;

  DFF dff0(.d(d[0]), .clk(clk), .q(q[0]));
  DFF dff1(.d(d[1]), .clk(clk), .q(q[1]));
  DFF dff2(.d(d[2]), .clk(clk), .q(q[2]));
  DFF dff3(.d(d[3]), .clk(clk), .q(q[3]));
  DFF dff4(.d(d[4]), .clk(clk), .q(q[4]));
  DFF dff5(.d(d[5]), .clk(clk), .q(q[5]));
  DFF dff6(.d(d[6]), .clk(clk), .q(q[6]));
  DFF dff7(.d(d[7]), .clk(clk), .q(q[7]));
endmodule