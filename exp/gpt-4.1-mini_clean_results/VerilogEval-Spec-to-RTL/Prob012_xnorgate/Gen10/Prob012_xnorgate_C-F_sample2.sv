module xnor_gate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Direct and optimal 1-bit XNOR implementation using built-in operator
    assign y = ~(a ^ b);
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Instantiate the reusable single-bit XNOR gate module
    xnor_gate u_xnor (
        .a(a),
        .b(b),
        .y(out)
    );
endmodule