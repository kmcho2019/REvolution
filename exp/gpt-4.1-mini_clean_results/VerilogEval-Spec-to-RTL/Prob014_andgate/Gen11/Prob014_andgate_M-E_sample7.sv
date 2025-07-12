module AndPrimitive (
    input  x,
    input  y,
    output z
);
    assign z = x & y;
endmodule

module TopModule (
    input  a,
    input  b,
    output out
);
    AndPrimitive and_inst (
        .x(a),
        .y(b),
        .z(out)
    );
endmodule