module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Maintain optimal XOR+AND implementation
    assign sum = a ^ b;
    assign cout = a & b;

endmodule