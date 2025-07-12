// Module A: computes z = (x ^ y) & x internally
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy;
    assign xor_xy = x ^ y;
    assign z = xor_xy & x;
endmodule

// Module B: computes z = ~(x ^ y) internally
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy;
    assign xor_xy = x ^ y;
    assign z = ~xor_xy;
endmodule

// Top-level module:
// Instantiates 2 A modules and 2 B modules, each with inputs x and y
// Connects first pair (A1, B1) outputs to OR gate
// Connects second pair (A2, B2) outputs to AND gate
// Final output is XOR of OR and AND outputs
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a1_out, b1_out, a2_out, b2_out;
    wire or_out, and_out;

    // Instantiate first A and B modules
    A a1 (
        .x(x),
        .y(y),
        .z(a1_out)
    );

    B b1 (
        .x(x),
        .y(y),
        .z(b1_out)
    );

    // Instantiate second A and B modules
    A a2 (
        .x(x),
        .y(y),
        .z(a2_out)
    );

    B b2 (
        .x(x),
        .y(y),
        .z(b2_out)
    );

    // OR of first pair outputs
    assign or_out = a1_out | b1_out;

    // AND of second pair outputs
    assign and_out = a2_out & b2_out;

    // Final XOR of OR and AND results
    assign z = or_out ^ and_out;
endmodule