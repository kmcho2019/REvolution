module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    wire ab_xor, ab_and, ab_or;
    assign ab_xor = a ^ b;
    assign ab_and = a & b;
    assign ab_or  = a | b;

    assign sum  = cin ? ~ab_xor : ab_xor;
    assign cout = cin ? ab_or : ab_and;
endmodule