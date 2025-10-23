module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

// Using a single expression for carry-out
assign sum = a ^ b ^ cin;
assign cout = a & b | (a | b) & cin;

endmodule

module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// Instantiating the FullAdder module with buffered inputs
wire buffered_a, buffered_b, buffered_cin;
assign buffered_a = a;
assign buffered_b = b;
assign buffered_cin = cin;

FullAdder fa1(
  .a(buffered_a),
  .b(buffered_b),
  .cin(buffered_cin),
  .sum(sum),
  .cout(cout)
);

endmodule