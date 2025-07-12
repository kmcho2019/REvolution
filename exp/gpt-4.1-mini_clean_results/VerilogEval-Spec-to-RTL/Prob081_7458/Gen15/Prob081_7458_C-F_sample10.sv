module TripleAndOr (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    input  f,
    output y
);
    wire and1, and2;

    // Use assign statements for clarity and minimal overhead
    assign and1 = a & b & c;
    assign and2 = d & e & f;
    assign y = and1 | and2;
endmodule

module DoubleAndOr (
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
    wire and1, and2;

    assign and1 = a & b;
    assign and2 = c & d;
    assign y = and1 | and2;
endmodule

module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    TripleAndOr u_triple_and_or (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .e(p1e),
        .f(p1f),
        .y(p1y)
    );

    DoubleAndOr u_double_and_or (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule