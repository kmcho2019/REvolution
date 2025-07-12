// Module A: z = (x XOR y) & x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B:
// Based on waveform, B behaves as:
// z = 1 when x=0 and y=0
// z = 0 for most other inputs, except when x=1,y=1 -> z=1
// One expression matching waveform:
// z = (~x & ~y) | (x & y)
// This matches the given waveform truth table.
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (~x & ~y) | (x & y);
endmodule

// Top-level module
// Instantiates two A modules and two B modules with same x, y inputs
// First A and B outputs go to an OR gate
// Second A and B outputs go to an AND gate
// Final output z is XOR of OR and AND gate outputs
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a1_out, b1_out;
    wire a2_out, b2_out;
    wire or_out, and_out;

    // First A instance
    A a1 (
        .x(x),
        .y(y),
        .z(a1_out)
    );

    // First B instance
    B b1 (
        .x(x),
        .y(y),
        .z(b1_out)
    );

    // OR of first A and B outputs
    assign or_out = a1_out | b1_out;

    // Second A instance
    A a2 (
        .x(x),
        .y(y),
        .z(a2_out)
    );

    // Second B instance
    B b2 (
        .x(x),
        .y(y),
        .z(b2_out)
    );

    // AND of second A and B outputs
    assign and_out = a2_out & b2_out;

    // Final output is XOR of OR and AND outputs
    assign z = or_out ^ and_out;
endmodule