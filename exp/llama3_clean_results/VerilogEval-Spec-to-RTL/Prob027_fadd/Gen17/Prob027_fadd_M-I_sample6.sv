// Full Adder Module
module FullAdder(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// Direct and efficient calculation of sum and carry-out
assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Top Module
module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

FullAdder fa(
  .a(a),
  .b(b),
  .cin(cin),
  .cout(cout),
  .sum(sum)
);

endmodule