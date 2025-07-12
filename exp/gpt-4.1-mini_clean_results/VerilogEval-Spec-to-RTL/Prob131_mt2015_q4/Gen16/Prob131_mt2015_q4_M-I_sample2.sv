// Module A: computes z = (xor_xy) & x
module A (
    input  wire x,
    input  wire xor_xy,
    output wire z
);
    assign z = xor_xy & x;
endmodule

// Module B: computes z = ~(xor_xy)
module B (
    input  wire xor_xy,
    output wire z
);
    assign z = ~xor_xy;
endmodule

// Top-level module:
// Computes xor_xy = x ^ y once
// Instantiates 2 A modules and 2 B modules using the shared xor_xy
// Connects first pair (A1, B1) outputs to OR gate
// Connects second pair (A2, B2) outputs to AND gate
// Final output is XOR of OR and AND outputs
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy;
    wire a1_out, b1_out, a2_out, b2_out;
    wire or_out, and_out;

    assign xor_xy = x ^ y;

    // Instantiate first A and B modules
    A a1 (
        .x(x),
        .xor_xy(xor_xy),
        .z(a1_out)
    );

    B b1 (
        .xor_xy(xor_xy),
        .z(b1_out)
    );

    // Instantiate second A and B modules
    A a2 (
        .x(x),
        .xor_xy(xor_xy),
        .z(a2_out)
    );

    B b2 (
        .xor_xy(xor_xy),
        .z(b2_out)
    );

    // OR of first pair outputs
    assign or_out = a1_out | b1_out;

    // AND of second pair outputs
    assign and_out = a2_out & b2_out;

    // Final XOR of OR and AND results
    assign z = or_out ^ and_out;
endmodule