// Comparator1 outputs 1 if input is 1, else 0
module Comparator1 (
    input  in,
    output out
);
    assign out = (in == 1'b1) ? 1'b1 : 1'b0;
endmodule

// Or3Combiner performs 3-input OR
module Or3Combiner (
    input  x,
    input  y,
    input  z,
    output out
);
    assign out = x | y | z;
endmodule

// TopModule uses three Comparator1 modules and one Or3Combiner module
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire a_valid, b_valid, c_valid;

    Comparator1 cmp_a (
        .in(a),
        .out(a_valid)
    );

    Comparator1 cmp_b (
        .in(b),
        .out(b_valid)
    );

    Comparator1 cmp_c (
        .in(c),
        .out(c_valid)
    );

    Or3Combiner or_gate (
        .x(a_valid),
        .y(b_valid),
        .z(c_valid),
        .out(out)
    );
endmodule