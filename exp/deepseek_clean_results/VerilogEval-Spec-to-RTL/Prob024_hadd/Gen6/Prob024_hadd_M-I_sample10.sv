module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Maintain optimal implementation
    assign sum = a ^ b;  // XOR for sum
    assign cout = a & b; // AND for carry-out

endmodule