module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // sum is XOR of all three inputs
    assign sum = a ^ b ^ cin;

    // carry-out is majority of a, b, and cin
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule