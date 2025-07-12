module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    wire sum1, carry1, carry2;

    // First half adder: sum and carry for a + b
    assign sum1 = a ^ b;
    assign carry1 = a & b;

    // Second half adder: sum and carry for sum1 + cin
    assign sum = sum1 ^ cin;
    assign carry2 = sum1 & cin;

    // Carry out is OR of carry1 and carry2
    assign cout = carry1 | carry2;

endmodule