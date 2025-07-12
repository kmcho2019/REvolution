module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

    // Generate sum using XOR operation
    assign sum = a ^ b;

    // Generate carry-out using AND operation
    assign cout = a & b;

endmodule