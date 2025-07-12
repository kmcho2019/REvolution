module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Standard full adder implementation with separate assignments:
    // sum = a XOR b XOR cin
    assign sum = a ^ b ^ cin;
    
    // cout = majority of (a, b, cin)
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule