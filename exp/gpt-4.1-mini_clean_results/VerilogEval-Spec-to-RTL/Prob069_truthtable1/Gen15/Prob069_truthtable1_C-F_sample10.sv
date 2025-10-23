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

module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);
    wire nx3;    // inverted x3
    wire m1, m2; // minterms

    assign nx3 = ~x3;

    // m1 = ~x3 & x2
    AND2 and_gate1 (
        .a(nx3),
        .b(x2),
        .y(m1)
    );

    // m2 = x3 & x1
    AND2 and_gate2 (
        .a(x3),
        .b(x1),
        .y(m2)
    );

    // f = m1 | m2
    OR2 or_gate (
        .a(m1),
        .b(m2),
        .y(f)
    );

endmodule