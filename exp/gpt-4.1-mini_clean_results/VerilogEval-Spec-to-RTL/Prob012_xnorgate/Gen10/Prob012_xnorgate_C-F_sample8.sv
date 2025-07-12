module xnor1 (
    input  wire a,
    input  wire b,
    output wire y
);
    // Direct 1-bit XNOR using built-in operator for minimal logic depth and area
    assign y = a ~^ b;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Instantiate the dedicated 1-bit XNOR module for clean modularity without overhead
    xnor1 u_xnor (
        .a(a),
        .b(b),
        .y(out)
    );
endmodule