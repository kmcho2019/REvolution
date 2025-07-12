module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire a_xor_b;
    
    // Shared XOR computation
    assign a_xor_b = a ^ b;
    
    // Sum calculation (unchanged)
    assign sum = a_xor_b ^ cin;
    
    // Optimized carry-out calculation
    assign cout = (a & b) | (cin & a_xor_b);
endmodule