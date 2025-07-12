module OR2 (
    input x,
    input y,
    output z
);
    assign z = x | y;
endmodule

module MUX2to1 (
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire or_out;

    OR2 or_inst (
        .x(b),
        .y(c),
        .z(or_out)
    );

    MUX2to1 mux_inst (
        .sel(or_out),
        .in0(1'b0),
        .in1(1'b1),
        .out(q)
    );
endmodule