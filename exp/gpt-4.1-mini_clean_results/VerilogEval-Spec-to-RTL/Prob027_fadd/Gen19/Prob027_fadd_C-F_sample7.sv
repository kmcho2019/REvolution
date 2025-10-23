module HalfAdder (
    input  x,
    input  y,
    output sum,
    output carry
);
    assign sum = x ^ y;
    assign carry = x & y;
endmodule

module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    wire carry1, carry2;

    // Instantiate two half adders only for generating carry signals modularly
    HalfAdder ha1(.x(a), .y(b), .sum(), .carry(carry1));  // sum output unused here
    HalfAdder ha2(.x(cin), .y(a ^ b), .sum(sum), .carry(carry2));  // sum computed here directly

    // Carry out is OR of the two half adder carries
    assign cout = carry1 | carry2;
endmodule