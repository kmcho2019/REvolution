// Module A: computes z = (x ^ y) & x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: outputs z = ~(x ^ y) matching the waveform
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Top-level module instantiating one A and one B,
// and using their outputs directly for OR and AND gates,
// then XOR of those results to produce final output z.
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a_out, b_out;
    wire or_out, and_out;

    // Single instances of A and B modules
    A a_inst (
        .x(x),
        .y(y),
        .z(a_out)
    );

    B b_inst (
        .x(x),
        .y(y),
        .z(b_out)
    );

    // OR and AND gates directly use A and B outputs (no redundant wires)
    assign or_out  = a_out | b_out;
    assign and_out = a_out & b_out;

    // Final XOR gate output
    assign z = or_out ^ and_out;

endmodule