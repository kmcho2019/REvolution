module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    assign sum = a ^ b;    // XOR for sum (optimal implementation)
    assign cout = a & b;   // AND for carry-out (optimal implementation)

endmodule