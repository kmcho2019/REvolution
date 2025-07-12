module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // sum is XOR of all three inputs
    assign sum = a ^ b ^ cin;

    // cout is true if any two or more inputs are true (majority function)
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule