module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Explicit XOR implementation for sum
    assign sum = a ^ b;
    
    // AND implementation for carry-out remains the same
    assign cout = a & b;
endmodule