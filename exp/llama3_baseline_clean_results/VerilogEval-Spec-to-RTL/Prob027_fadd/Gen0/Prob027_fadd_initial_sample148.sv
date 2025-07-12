module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

assign sum = a ^ b ^ cin; // The sum bit is set if an odd number of input bits are set
assign cout = (a & b) | (a & cin) | (b & cin); // The carry bit is set if at least two input bits are set

endmodule