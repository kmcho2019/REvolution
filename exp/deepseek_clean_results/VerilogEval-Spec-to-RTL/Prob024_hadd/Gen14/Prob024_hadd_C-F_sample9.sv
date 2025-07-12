module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);

    // Minimal and optimal continuous assignments
    assign sum  = a ^ b;  // XOR for sum
    assign cout = a & b;  // AND for carry-out

endmodule