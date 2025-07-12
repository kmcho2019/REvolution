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
    
    HalfAdder HA1(.x(a), .y(b), .sum(s1), .cout(c1));
    HalfAdder HA2(.x(s1), .y(cin), .sum(sum), .cout(c2));
    
    assign cout = c1 | c2;
endmodule