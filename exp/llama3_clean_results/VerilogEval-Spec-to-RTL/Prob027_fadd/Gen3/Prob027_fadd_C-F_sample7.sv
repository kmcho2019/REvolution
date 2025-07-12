// TopModule: a full adder that adds three one-bit numbers (including carry-in) and produces a sum and carry-out
module TopModule(
    input  a,  // first input bit
    input  b,  // second input bit
    input  cin,  // carry-in bit
    output cout,  // carry-out bit
    output sum  // sum bit
);

// Calculate the sum using an XOR operation among the three inputs
assign sum = a ^ b ^ cin;

// Calculate the carry-out by checking all combinations where the sum of any two inputs is 1
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule