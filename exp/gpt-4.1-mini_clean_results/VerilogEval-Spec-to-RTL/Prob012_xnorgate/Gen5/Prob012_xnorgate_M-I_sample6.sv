module TopModule(
    input  wire a,
    input  wire b,
    output wire out
);

// Instantiate an explicit XNOR gate primitive for synthesis clarity
xnor u_xnor (
    .a(a),
    .b(b),
    .y(out)
);

endmodule