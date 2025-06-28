module FullAdder (
  input a, b, cin,
  output sum, cout
);

assign {sum, cout} = a + b + cin;

endmodule

module TopModule (
  input [3:0] x,
  input [3:0] y,
  output [4:0] sum
);

reg [3:0] inter_sum;
reg carry_out;

FullAdder FA0(x[0], y[0], 1'b0, inter_sum[0], carry_out);
FullAdder FA1(x[1], y[1], carry_out, inter_sum[1], carry_out);
FullAdder FA2(x[2], y[2], carry_out, inter_sum[2], carry_out);
FullAdder FA3(x[3], y[3], carry_out, inter_sum[3], sum[4]);

assign {sum[3:0], sum[4]} = {inter_sum, carry_out};

endmodule