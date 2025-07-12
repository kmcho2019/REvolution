module OR2 (input x, input y, output z);
    assign z = x | y;
endmodule

module AND2 (input x, input y, output z);
    assign z = x & y;
endmodule

module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire or_out;
    wire and_out;

    // OR b and c
    OR2 u_or (
        .x(b),
        .y(c),
        .z(or_out)
    );

    // AND the or_out with constant 1'b1 (using input a tied to 1'b1 to avoid constants in port)
    AND2 u_and (
        .x(or_out),
        .y(1'b1),
        .z(and_out)
    );

    assign q = and_out;
endmodule