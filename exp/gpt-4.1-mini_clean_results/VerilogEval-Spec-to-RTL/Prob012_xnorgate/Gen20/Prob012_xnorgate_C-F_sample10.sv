module xnor_gate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Minimal, direct XNOR implementation with built-in operator
    assign y = a ~^ b;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Instantiate the reusable XNOR gate module for modularity and clarity
    xnor_gate u_xnor (
        .a(a),
        .b(b),
        .y(out)
    );
endmodule