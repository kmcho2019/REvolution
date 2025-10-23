module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Full adder implementation with optimal PPA:
    // sum = a XOR b XOR cin (1-bit sum)
    // cout = majority function (1 if ≥2 inputs are 1)
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule