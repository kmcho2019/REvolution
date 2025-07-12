module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Full adder implementation with optimal PPA and clarity:
    // sum = a XOR b XOR cin (3-input XOR)
    assign sum = a ^ b ^ cin;
    
    // carry-out = majority function (a AND b) OR (a AND cin) OR (b AND cin)
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule