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

  wire [3:0] carry;
  wire [3:0] sum_out;

  FullAdder FA0 (.a(x[0]), .b(y[0]), .cin(1'b0), .sum(sum_out[0]), .cout(carry[0]));
  FullAdder FA1 (.a(x[1]), .b(y[1]), .cin(carry[0]), .sum(sum_out[1]), .cout(carry[1]));
  FullAdder FA2 (.a(x[2]), .b(y[2]), .cin(carry[1]), .sum(sum_out[2]), .cout(carry[2]));
  FullAdder FA3 (.a(x[3]), .b(y[3]), .cin(carry[2]), .sum(sum_out[3]), .cout(carry[3]));

  assign {sum[3:0], sum[4]} = {sum_out, carry[3]];

endmodule