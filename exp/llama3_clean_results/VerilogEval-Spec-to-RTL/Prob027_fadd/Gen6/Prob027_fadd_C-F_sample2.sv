// TopModule: a full adder implemented using direct logic
module TopModule(
    input  a,  // first input bit
    input  b,  // second input bit
    input  cin,  // carry-in bit
    output cout,  // carry-out bit
    output sum  // sum bit
);

// Direct logic implementation of the full adder
assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule