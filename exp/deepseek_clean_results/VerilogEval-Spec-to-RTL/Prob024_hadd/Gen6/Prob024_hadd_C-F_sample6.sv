module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Direct gate-level implementation for optimal clarity and efficiency
    assign sum = a ^ b;  // XOR for sum
    assign cout = a & b; // AND for carry-out

endmodule