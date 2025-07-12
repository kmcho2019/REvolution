// TopModule: a simplified full adder that adds three one-bit numbers (including carry-in) and produces a sum and carry-out
module TopModule(
    input  a,  // first input bit
    input  b,  // second input bit
    input  cin,  // carry-in bit
    output cout,  // carry-out bit
    output sum  // sum bit
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule