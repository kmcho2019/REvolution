// Module A: Implements z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: Implements z = XNOR of x and y (z = ~(x ^ y))
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Top-level module:
// - Inputs: x, y
// - Output: z
//
// Internally:
// - Two pairs of submodules (A and B) are specified with identical inputs (x, y).
// - The output of the first pair's A and B connect to a 2-input OR gate.
// - The output of the second pair's A and B connect to a 2-input AND gate.
// - The OR and AND outputs are then XORed to produce z.
//
// Since all four submodules receive identical inputs (x, y),
// their outputs are identical. Therefore, to optimize area and power,
// we instantiate only one A and one B module and reuse their outputs.
//
// This maintains the logical equivalence of the original structure.
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    // Outputs from single instances of A and B modules
    wire a_out;
    wire b_out;

    // Intermediate signals for OR and AND gates
    wire or_out;
    wire and_out;

    // Single instance of A module (used for both pairs)
    A a_inst (
        .x(x),
        .y(y),
        .z(a_out)
    );

    // Single instance of B module (used for both pairs)
    B b_inst (
        .x(x),
        .y(y),
        .z(b_out)
    );

    // First pair output: OR of A and B outputs
    assign or_out = a_out | b_out;

    // Second pair output: AND of A and B outputs
    assign and_out = a_out & b_out;

    // Final output: XOR of OR and AND outputs
    assign z = or_out ^ and_out;
endmodule