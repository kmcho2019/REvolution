module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

// The sum logic remains the same as it's already optimized
assign sum = a ^ b ^ cin;

// Simplifying the carry-out logic by directly using the equation
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule