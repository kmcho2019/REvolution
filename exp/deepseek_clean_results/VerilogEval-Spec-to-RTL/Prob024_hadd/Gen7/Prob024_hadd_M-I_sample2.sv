module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Direct XOR implementation for sum
    assign sum = a ^ b;
    
    // Carry-out remains as AND gate
    assign cout = a & b;
endmodule