// Module A: z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: Matches the waveform behavior, z = XNOR(x, y)
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Top-level module:
// - Instantiate one A and one B module with inputs x and y.
// - Reuse their outputs as if they were from two pairs.
// - Combine first pair outputs with OR.
// - Combine second pair outputs with AND.
// - XOR the OR and AND outputs to produce final output z.
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a_out, b_out;

    // Single instance of A and B modules
    A a_inst (.x(x), .y(y), .z(a_out));
    B b_inst (.x(x), .y(y), .z(b_out));

    // First pair output: OR of A and B outputs
    wire or_out = a_out | b_out;

    // Second pair output: AND of A and B outputs
    wire and_out = a_out & b_out;

    // Final output: XOR of the OR and AND results
    assign z = or_out ^ and_out;
endmodule