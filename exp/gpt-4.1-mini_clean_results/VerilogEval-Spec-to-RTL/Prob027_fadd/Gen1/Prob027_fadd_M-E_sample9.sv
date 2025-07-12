module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    wire sum1, carry1, carry2;

    // First half adder: a + b
    assign sum1 = a ^ b;
    assign carry1 = a & b;

    // Second half adder: sum1 + cin
    assign sum = sum1 ^ cin;
    assign carry2 = sum1 & cin;

    // Carry out is OR of two half adder carries
    assign cout = carry1 | carry2;

endmodule