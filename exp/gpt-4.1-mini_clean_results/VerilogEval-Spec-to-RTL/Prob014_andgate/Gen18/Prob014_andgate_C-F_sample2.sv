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
    // Directly connect the output of AndPrimitive to out for minimal overhead
    AndPrimitive and_inst (
        .x(a),
        .y(b),
        .z(out)
    );
endmodule