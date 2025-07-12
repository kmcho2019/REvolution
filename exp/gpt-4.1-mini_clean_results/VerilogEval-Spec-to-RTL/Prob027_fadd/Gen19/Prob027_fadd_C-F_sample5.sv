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
    wire s1, c1;

    // First half adder adds a and b
    HalfAdder HA1 (a, b, s1, c1);

    // Second half adder adds sum from first plus cin
    HalfAdder HA2 (s1, cin, sum, /* carry out of second half adder */ );

    // Calculate cout as c1 OR (cin AND s1)
    assign cout = c1 | (cin & s1);

endmodule