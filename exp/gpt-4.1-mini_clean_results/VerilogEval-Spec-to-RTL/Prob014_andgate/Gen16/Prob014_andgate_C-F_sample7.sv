// Define AndPrimitive as a wrapper around the built-in and gate primitive for minimal overhead and maximal clarity
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
    // Instantiate AndPrimitive for modularity and hierarchical clarity
    AndPrimitive and_inst (
        .x(a),
        .y(b),
        .z(out)
    );
endmodule