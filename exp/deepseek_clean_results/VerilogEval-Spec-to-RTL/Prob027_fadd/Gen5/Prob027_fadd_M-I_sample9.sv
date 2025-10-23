module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire a_xor_b;
    
    // Shared XOR term for both sum and cout
    assign a_xor_b = a ^ b;
    
    // sum = a XOR b XOR cin (3-input XOR)
    assign sum = a_xor_b ^ cin;
    
    // Optimized carry-out: (a AND b) OR (cin AND (a XOR b))
    assign cout = (a & b) | (cin & a_xor_b);
endmodule