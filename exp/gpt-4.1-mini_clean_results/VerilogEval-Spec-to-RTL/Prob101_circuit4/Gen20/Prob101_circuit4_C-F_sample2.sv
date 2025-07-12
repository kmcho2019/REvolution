module OR2 (
    input x,
    input y,
    output z
);
    assign z = x | y;
endmodule

module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire or_out;

    OR2 u_or (
        .x(b),
        .y(c),
        .z(or_out)
    );

    assign q = or_out;
endmodule