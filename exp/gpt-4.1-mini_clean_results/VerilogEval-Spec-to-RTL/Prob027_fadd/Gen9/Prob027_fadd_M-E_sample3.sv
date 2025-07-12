module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // sum is XOR of all three inputs
    assign sum = a ^ b ^ cin;

    // cout is 1 if any two or more inputs are 1
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule