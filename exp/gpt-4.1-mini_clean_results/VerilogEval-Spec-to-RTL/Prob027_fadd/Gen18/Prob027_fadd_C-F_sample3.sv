module HalfAdder (
    input  x,
    input  y,
    output sum,
    output cout
);
    assign sum = x ^ y;
    assign cout = x & y;
endmodule

module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    wire s1, c1, c2;

    HalfAdder HA1(a, b, s1, c1);
    HalfAdder HA2(s1, cin, sum, c2);

    assign cout = c1 | c2;

endmodule