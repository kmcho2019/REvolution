// Parameterized XNOR gate module: reusable for multiple widths.
// Uses built-in XNOR operator for minimal logic depth.
module xnor_gate #(
    parameter WIDTH = 1
)(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] y
);
    assign y = ~(a ^ b);
endmodule

// Top-level module implementing 1-bit XNOR operation.
// Instantiates the reusable xnor_gate module with WIDTH=1 for modularity and efficiency.
module TopModule (
    input  a,
    input  b,
    output out
);
    xnor_gate #(.WIDTH(1)) u_xnor (
        .a(a),
        .b(b),
        .y(out)
    );
endmodule