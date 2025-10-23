module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // Sum is XOR of a, b, and cin
    assign sum = a ^ b ^ cin;
    // Carry out is majority function: any two or more inputs are high
    assign cout = (a & b) | (b & cin) | (cin & a);
endmodule