module xnor_gate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Single-level direct XNOR using built-in operator for minimal logic depth and area
    assign y = a ~^ b;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Instantiate the simple xnor_gate module to maintain modularity and clarity
    xnor_gate u_xnor (
        .a(a),
        .b(b),
        .y(out)
    );
endmodule