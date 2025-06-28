module FullAdder (
  input a, b, cin,
  output sum, cout
);

  assign {cout, sum} = a + b + cin;

endmodule

module TopModule (
  input [3:0] x,
  input [3:0] y,
  output [4:0] sum
);

  wire [4:0] c;
  FullAdder fa0(x[0], y[0], 1'b0, sum[0], c[1]);
  FullAdder fa1(x[1], y[1], c[1], sum[1], c[2]);
  FullAdder fa2(x[2], y[2], c[2], sum[2], c[3]);
  FullAdder fa3(x[3], y[3], c[3], sum[3], sum[4]);

endmodule