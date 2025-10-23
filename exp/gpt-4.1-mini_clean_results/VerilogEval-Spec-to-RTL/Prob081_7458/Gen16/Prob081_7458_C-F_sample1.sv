module AndGateN #(parameter WIDTH = 2) (
    input  wire [WIDTH-1:0] in,
    output wire             out
);
    assign out = &in; // Reduction AND for WIDTH inputs
endmodule

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

    AndGateN #(.WIDTH(3)) and_gate1 (.in({a, b, c}), .out(and1));
    AndGateN #(.WIDTH(3)) and_gate2 (.in({d, e, f}), .out(and2));

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

    AndGateN #(.WIDTH(2)) and_gate1 (.in({a, b}), .out(and1));
    AndGateN #(.WIDTH(2)) and_gate2 (.in({c, d}), .out(and2));

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

    TripleAndOr triple_and_or_inst (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .e(p1e),
        .f(p1f),
        .y(p1y)
    );

    DoubleAndOr double_and_or_inst (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule