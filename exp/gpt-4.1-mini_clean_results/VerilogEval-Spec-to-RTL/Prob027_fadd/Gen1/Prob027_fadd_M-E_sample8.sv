module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    wire sum1, carry1, carry2;

    // First half adder: sum1 = a XOR b, carry1 = a AND b
    assign sum1 = a ^ b;
    assign carry1 = a & b;

    // Second half adder: sum = sum1 XOR cin, carry2 = sum1 AND cin
    assign sum = sum1 ^ cin;
    assign carry2 = sum1 & cin;

    // Carry out is OR of both half adder carries
    assign cout = carry1 | carry2;
endmodule