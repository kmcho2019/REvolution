// Optional reusable XNOR gate module for modularity and reusability
// Uncomment to instantiate this module inside TopModule instead of using direct assign
/*
module xnor_gate(
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a ~^ b;
endmodule
*/

module TopModule(
    input  wire a,
    input  wire b,
    output wire out
);
    // Directly implement XNOR with continuous assignment for best PPA
    assign out = a ~^ b;

    // Alternative modular instantiation (commented out):
    // xnor_gate u_xnor (
    //     .a(a),
    //     .b(b),
    //     .y(out)
    // );
endmodule