// Primitive 3-input OR gate module
module Or3 (
    input  x,
    input  y,
    input  w,
    output z
);
    assign z = x | y | w;
endmodule

// TopModule implements the K-map function as out = a | b | c using Or3 gate
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    Or3 or3_inst (
        .x(a),
        .y(b),
        .w(c),
        .z(out)
    );
endmodule