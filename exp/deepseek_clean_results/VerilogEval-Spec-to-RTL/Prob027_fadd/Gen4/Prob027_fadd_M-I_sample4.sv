module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Optimal sum calculation remains XOR chain
    assign sum = a ^ b ^ cin;
    
    // Optimized carry-out using majority function with AOI-like structure
    // Equivalent to: at least two of three inputs are 1
    assign cout = (a & b) | (cin & (a | b));
endmodule