module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);
    // Optimized half adder using continuous assignments
    assign sum = a ^ b;   // XOR operation for sum
    assign cout = a & b;  // AND operation for carry-out
endmodule