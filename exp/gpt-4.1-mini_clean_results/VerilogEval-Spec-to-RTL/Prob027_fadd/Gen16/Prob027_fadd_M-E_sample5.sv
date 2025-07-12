module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    // Sum is the XOR of all three inputs
    assign sum = a ^ b ^ cin;

    // Carry out is high if at least two inputs are high
    assign cout = (a & b) | (b & cin) | (cin & a);

endmodule