module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // sum is the XOR of all three inputs
    assign sum = a ^ b ^ cin;
    // cout is set when at least two inputs are high
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule