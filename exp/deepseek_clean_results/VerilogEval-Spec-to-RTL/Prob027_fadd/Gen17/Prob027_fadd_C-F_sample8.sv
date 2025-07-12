module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Internal signals
    wire s1, c1;
    
    // First half-adder: a + b
    assign s1 = a ^ b;
    assign c1 = a & b;
    
    // Final sum calculation
    assign sum = s1 ^ cin;
    
    // Optimized carry-out using majority function
    assign cout = c1 | (b & cin) | (a & cin);
endmodule