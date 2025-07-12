module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Standard full adder implementation:
    // sum = XOR of all inputs (a XOR b XOR cin)
    assign sum = a ^ b ^ cin;
    
    // carry-out = majority function (at least two 1's among a, b, cin)
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule