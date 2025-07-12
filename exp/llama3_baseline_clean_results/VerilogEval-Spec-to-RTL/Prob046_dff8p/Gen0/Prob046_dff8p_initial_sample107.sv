module DFF(clk, reset, d, q);
  input clk, reset;
  input [7:0] d;
  output [7:0] q;
  reg [7:0] q;

  always @(negedge clk)
    if (reset)
      q <= 8'h34;
    else
      q <= d;
endmodule

module TopModule(clk, reset, d, q);
  input clk, reset;
  input [7:0] d;
  output [7:0] q;

  reg [7:0] q;
  DFF u_dff (.clk(clk), .reset(reset), .d(d), .q(q));

  assign q = u_dff.q;
endmodule