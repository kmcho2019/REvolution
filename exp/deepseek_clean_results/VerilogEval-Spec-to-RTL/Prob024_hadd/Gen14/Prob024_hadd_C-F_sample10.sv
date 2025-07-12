module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Direct gate-level implementation
    assign sum = a ^ b;  // XOR for sum bit
    assign cout = a & b; // AND for carry-out

endmodule