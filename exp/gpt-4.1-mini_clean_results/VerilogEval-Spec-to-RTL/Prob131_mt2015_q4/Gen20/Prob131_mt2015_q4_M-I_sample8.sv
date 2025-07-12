// Module A: z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire xor_xy,
    output wire z
);
    assign z = xor_xy & x;
endmodule

// Module B: z = ~(x XOR y)
// Outputs inv_xor_xy input
module B (
    input  wire inv_xor_xy,
    output wire z
);
    assign z = inv_xor_xy;
endmodule

// Top-level module optimized:
// Instantiate only one A and one B module, reuse their outputs to produce final output.
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy;
    wire inv_xor_xy;

    // Compute shared signals once
    assign xor_xy = x ^ y;
    assign inv_xor_xy = ~xor_xy;

    // Instantiate one A and one B module
    wire a_out;
    wire b_out;

    A a_inst (
        .x(x),
        .xor_xy(xor_xy),
        .z(a_out)
    );

    B b_inst (
        .inv_xor_xy(inv_xor_xy),
        .z(b_out)
    );

    // Replicate the outputs as in original:
    // OR of first pair (A, B)
    wire or_out = a_out | b_out;
    // AND of second pair (A, B)
    wire and_out = a_out & b_out;

    // Final output z is XOR of or_out and and_out
    assign z = or_out ^ and_out;
endmodule