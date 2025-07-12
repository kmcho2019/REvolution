module FullAdder(a, b, cin, sum, cout);
  input a, b, cin;
  output sum, cout;

  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module TopModule(x, y, sum);
  input [3:0] x;
  input [3:0] y;
  output [4:0] sum;

  wire c0, c1, c2, c3;

  FullAdder fa0(x[0], y[0], 1'b0, sum[0], c0);
  FullAdder fa1(x[1], y[1], c0, sum[1], c1);
  FullAdder fa2(x[2], y[2], c1, sum[2], c2);
  FullAdder fa3(x[3], y[3], c2, sum[3], c3);

  assign sum[4] = c3;
endmodule