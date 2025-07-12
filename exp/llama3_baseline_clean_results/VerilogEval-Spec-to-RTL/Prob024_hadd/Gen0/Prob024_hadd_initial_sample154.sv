module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);
    
    // XOR operation for sum
    assign sum = a ^ b;
    
    // AND operation for carry-out
    assign cout = a & b;

endmodule