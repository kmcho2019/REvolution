module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire a_xor_b;
    
    // Shared intermediate term
    assign a_xor_b = a ^ b;
    
    // Sum remains the same (optimal XOR chain)
    assign sum = a_xor_b ^ cin;
    
    // Optimized carry-out: (a&b) | ((a^b)&cin)
    assign cout = (a & b) | (a_xor_b & cin);
endmodule