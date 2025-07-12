module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

wire sum0, sum1, cout0, cout1;

// Calculate sum without considering cin
assign sum0 = a ^ b;

// Calculate carry-out without considering cin
assign cout0 = a & b;

// Use a multiplexer to select between sum0 and the inverted sum0 based on cin
assign sum = (cin)? (~sum0) : sum0;

// Use another multiplexer to select between cout0 and the OR of a, b, and cin based on cin
assign cout = (cin)? (a | b | cin) : cout0;

endmodule