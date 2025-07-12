module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // Sum is XOR of all three inputs
    assign sum = a ^ b ^ cin;

    // Carry out is majority logic: at least two inputs are 1
    assign cout = (a & b) | (b & cin) | (cin & a);
endmodule