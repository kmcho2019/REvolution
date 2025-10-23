module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Standard full adder implementation:
    // sum = a XOR b XOR cin
    // cout = majority of (a, b, cin)
    assign {cout, sum} = {(a & b) | (a & cin) | (b & cin), a ^ b ^ cin};
endmodule