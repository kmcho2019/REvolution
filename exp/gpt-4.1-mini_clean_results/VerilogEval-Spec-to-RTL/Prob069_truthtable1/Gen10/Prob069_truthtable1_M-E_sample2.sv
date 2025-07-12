module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    wire not_x3;
    wire and0, and1;

    // Invert x3
    not U_not_x3(not_x3, x3);

    // and0 = ~x3 & x2
    and U_and0(and0, not_x3, x2);

    // and1 = x3 & x1
    and U_and1(and1, x3, x1);

    // f = and0 | and1
    or U_or_f(f, and0, and1);

endmodule