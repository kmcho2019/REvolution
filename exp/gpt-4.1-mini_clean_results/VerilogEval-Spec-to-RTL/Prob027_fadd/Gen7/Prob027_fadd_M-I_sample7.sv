module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // sum is the XOR of all three inputs
    assign sum = a ^ b ^ cin;

    // cout is majority function of a, b, cin
    assign cout = (a & b) | (b & cin) | (cin & a);
endmodule