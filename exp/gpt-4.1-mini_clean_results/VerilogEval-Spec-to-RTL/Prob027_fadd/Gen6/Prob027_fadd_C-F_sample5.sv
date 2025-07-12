module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // Intermediate sums and carries similar to half adders
    wire sum1 = a ^ b;
    wire cout1 = a & b;
    wire cout2 = sum1 & cin;

    assign sum = sum1 ^ cin;
    assign cout = cout1 | cout2;

endmodule