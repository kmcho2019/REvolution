module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Full adder implementation using standard equations:
    // sum = a XOR b XOR cin (parity function)
    assign sum = a ^ b ^ cin;
    
    // carry-out = majority function (at least two 1's among inputs)
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule