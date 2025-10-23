module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Optimal sum calculation (shared with carry logic)
    wire ab_xor = a ^ b;
    assign sum = ab_xor ^ cin;
    
    // Superior carry calculation using shared XOR term
    assign cout = (a & b) | (cin & ab_xor);
endmodule