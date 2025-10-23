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
    // Direct continuous assign for minimal overhead and optimal PPA
    assign out = a & b;
endmodule