// Module A: computes z = (xor_xy) & x using precomputed xor_xy input
module A (
    input  wire x,
    input  wire y,          // keep y for interface consistency, but unused here
    input  wire xor_xy,     // precomputed x ^ y input
    output wire z
);
    assign z = xor_xy & x;
endmodule

// Module B: computes z = ~xor_xy using precomputed xor_xy input
module B (
    input  wire x,          // keep x,y for interface consistency, unused internally
    input  wire y,
    input  wire xor_xy,
    output wire z
);
    assign z = ~xor_xy;
endmodule

// Top-level module:
// Precomputes xor_xy = x ^ y once, passes to all A and B instances
// Instantiates 2 A and 2 B modules, each receiving x, y, and xor_xy
// Connects first pair outputs (A1, B1) to OR gate
// Connects second pair outputs (A2, B2) to AND gate
// Final output is XOR of OR and AND results
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy;

    wire a1_out, b1_out;
    wire a2_out, b2_out;
    wire or_out, and_out;

    // Precompute XOR once for all submodules
    assign xor_xy = x ^ y;

    // Instantiate first A and B modules with precomputed xor_xy
    A a1 (
        .x(x),
        .y(y),
        .xor_xy(xor_xy),
        .z(a1_out)
    );

    B b1 (
        .x(x),
        .y(y),
        .xor_xy(xor_xy),
        .z(b1_out)
    );

    // Instantiate second A and B modules
    A a2 (
        .x(x),
        .y(y),
        .xor_xy(xor_xy),
        .z(a2_out)
    );

    B b2 (
        .x(x),
        .y(y),
        .xor_xy(xor_xy),
        .z(b2_out)
    );

    // OR gate of first pair outputs
    assign or_out = a1_out | b1_out;

    // AND gate of second pair outputs
    assign and_out = a2_out & b2_out;

    // Final XOR gate for output
    assign z = or_out ^ and_out;
endmodule