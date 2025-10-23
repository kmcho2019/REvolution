// Optional gate-level module definitions (educational):
/*
module And3 (
    input x,
    input y,
    input z,
    output w
);
    assign w = x & y & z;
endmodule

module Or3 (
    input x,
    input y,
    input z,
    output w
);
    assign w = x | y | z;
endmodule

module Not1 (
    input x,
    output y
);
    assign y = ~x;
endmodule
*/

// TopModule implements: out = (b | c) | (~b & ~c & a) equivalent to a | b | c
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire not_b, not_c;
    wire and_term;

    assign not_b = ~b;
    assign not_c = ~c;
    assign and_term = not_b & not_c & a;
    assign out = (b | c) | and_term;
endmodule