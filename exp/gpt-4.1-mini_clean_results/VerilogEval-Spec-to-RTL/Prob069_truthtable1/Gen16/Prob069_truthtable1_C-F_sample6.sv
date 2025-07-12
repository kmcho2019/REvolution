module AND2 (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a & b;
endmodule

module OR2 (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a | b;
endmodule

// 2:1 MUX implemented structurally with continuous assignment for NOT
module MUX2to1 (
    input  wire sel,
    input  wire d0,
    input  wire d1,
    output wire y
);
    wire nsel, s0, s1;

    assign nsel = ~sel;          // invert select without instantiating a module
    assign s0 = d0 & nsel;
    assign s1 = d1 & sel;
    assign y  = s0 | s1;
endmodule

module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);
    wire nx3;
    wire and_term;
    wire or_term;

    assign nx3 = ~x3;            // continuous assignment for inversion

    // and_term = ~x3 & x2
    AND2 and_gate(.a(nx3), .b(x2), .y(and_term));
    // or_term = x3 | x2
    OR2  or_gate(.a(x3),  .b(x2), .y(or_term));
    // f = mux(x1, and_term, or_term)
    MUX2to1 mux(.sel(x1), .d0(and_term), .d1(or_term), .y(f));
endmodule