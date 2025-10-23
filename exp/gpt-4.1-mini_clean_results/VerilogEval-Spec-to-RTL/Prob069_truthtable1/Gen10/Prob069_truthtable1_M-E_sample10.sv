module AND2 (
    input  a,
    input  b,
    output y
);
    assign y = a & b;
endmodule

module OR2 (
    input  a,
    input  b,
    output y
);
    assign y = a | b;
endmodule

module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    wire m1, m2;

    AND2 and_gate1 (
        .a(~x3),
        .b(x2),
        .y(m1)
    );

    AND2 and_gate2 (
        .a(x3),
        .b(x1),
        .y(m2)
    );

    OR2 or_gate (
        .a(m1),
        .b(m2),
        .y(f)
    );

endmodule