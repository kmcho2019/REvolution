module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Internal signals
    wire s1;
    
    // First XOR for sum calculation
    assign s1 = a ^ b;
    
    // Final sum calculation
    assign sum = s1 ^ cin;
    
    // Optimized carry-out using shared intermediate signal
    assign cout = (a & b) | (cin & s1);
endmodule