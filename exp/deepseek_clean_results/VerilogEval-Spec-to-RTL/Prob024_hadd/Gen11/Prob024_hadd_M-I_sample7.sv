module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Direct XOR implementation for sum
    assign sum = a ^ b;
    
    // Optimal AND implementation for carry-out
    assign cout = a & b;
endmodule