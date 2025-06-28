module FullAdder(
  input a,
  input b,
  input cin,
  output sum,
  output cout
);

assign {cout, sum} = a + b + cin;

endmodule

module TopModule (
  input [3:0] x,
  input [3:0] y,
  output [4:0] sum
);

wire [3:0] carry;
wire [4:0] sum_temp;

FullAdder fa0(x[0], y[0], 0, sum_temp[0], carry[0]);
FullAdder fa1(x[1], y[1], carry[0], sum_temp[1], carry[1]);
FullAdder fa2(x[2], y[2], carry[1], sum_temp[2], carry[2]);
FullAdder fa3(x[3], y[3], carry[2], sum_temp[3], sum_temp[4]);

assign sum = sum_temp;

endmodule