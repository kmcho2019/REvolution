module FullAdder (
  input a,
  input b,
  input cin,
  output sum,
  output cout
);

  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (cin & (a ^ b));

endmodule

module TopModule (
  input [3:0] x,
  input [3:0] y,
  output [4:0] sum
);

  wire [3:0] carry;
  wire [4:0] overflow;

  FullAdder FA0(x[0], y[0], 0, sum[0], carry[0]);
  FullAdder FA1(x[1], y[1], carry[0], sum[1], carry[1]);
  FullAdder FA2(x[2], y[2], carry[1], sum[2], carry[2]);
  FullAdder FA3(x[3], y[3], carry[2], sum[3], carry[3]);

  assign overflow[0] = carry[0] & carry[1];
  assign overflow[1] = carry[1] & carry[2];
  assign overflow[2] = carry[2] & carry[3];
  assign overflow[3] = carry[3];

  assign sum[4] = overflow[3];

endmodule