module AndPrimitive (
    input  x,
    input  y,
    output z
);
    and (z, x, y);
endmodule

module TopModule (
    input  a,
    input  b,
    output out
);
    // Instantiate the modular AND primitive directly for clarity and minimal logic depth
    AndPrimitive and_inst (
        .x(a),
        .y(b),
        .z(out)
    );
endmodule