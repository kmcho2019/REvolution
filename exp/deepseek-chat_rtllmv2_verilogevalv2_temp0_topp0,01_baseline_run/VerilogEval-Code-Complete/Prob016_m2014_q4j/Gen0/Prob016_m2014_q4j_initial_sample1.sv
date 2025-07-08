module TopModule (
  input [3:0] x,
  input [3:0] y,
  output [4:0] sum
);

  wire [3:0] c;  // Carry wires between full adders

  // First full adder (LSB)
  FullAdder fa0 (
    .a(x[0]),
    .b(y[0]),
    .cin(1'b0),   // No carry-in for LSB
    .sum(sum[0]),
    .cout(c[0])
  );

  // Second full adder
  FullAdder fa1 (
    .a(x[1]),
    .b(y[1]),
    .cin(c[0]),
    .sum(sum[1]),
    .cout(c[1])
  );

  // Third full adder
  FullAdder fa2 (
    .a(x[2]),
    .b(y[2]),
    .cin(c[1]),
    .sum(sum[2]),
    .cout(c[2])
  );

  // Fourth full adder (MSB)
  FullAdder fa3 (
    .a(x[3]),
    .b(y[3]),
    .cin(c[2]),
    .sum(sum[3]),
    .cout(sum[4])  // Overflow bit
  );

endmodule

// Full adder module definition
module FullAdder (
  input a,
  input b,
  input cin,
  output sum,
  output cout
);
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);
endmodule