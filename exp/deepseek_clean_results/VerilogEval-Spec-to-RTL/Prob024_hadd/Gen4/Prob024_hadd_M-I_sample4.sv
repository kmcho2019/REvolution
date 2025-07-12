module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Optimal implementation using minimal gates
    assign sum = a ^ b;   // XOR for sum
    assign cout = a & b;  // AND for carry-out

endmodule