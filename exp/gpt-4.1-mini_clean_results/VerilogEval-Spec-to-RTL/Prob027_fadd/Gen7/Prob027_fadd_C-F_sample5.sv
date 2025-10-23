module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    wire ab_xor, ab_and;

    assign ab_xor = a ^ b;
    assign ab_and = a & b;

    assign sum = ab_xor ^ cin;
    assign cout = ab_and | (cin & ab_xor);

endmodule