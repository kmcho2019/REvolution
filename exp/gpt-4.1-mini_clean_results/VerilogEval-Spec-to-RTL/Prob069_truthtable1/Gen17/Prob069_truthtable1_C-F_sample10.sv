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
    wire term0, term1;

    // term0 = ~x3 & x2 (inversion inline without extra wire)
    AND2 and0 (
        .a(~x3),
        .b(x2),
        .y(term0)
    );

    // term1 = x3 & x1
    AND2 and1 (
        .a(x3),
        .b(x1),
        .y(term1)
    );

    // f = term0 | term1
    OR2 or0 (
        .a(term0),
        .b(term1),
        .y(f)
    );
endmodule