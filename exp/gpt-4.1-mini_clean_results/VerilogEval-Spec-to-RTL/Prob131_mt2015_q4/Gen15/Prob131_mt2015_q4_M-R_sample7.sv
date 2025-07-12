// Module A: z = (x XOR y) & x
// Inputs: x, xor_xy
module A (
    input  wire x,
    input  wire xor_xy,
    output wire z
);
    assign z = xor_xy & x;
endmodule

// Module B: z = ~(x XOR y)
// Inputs: xor_xy, output is inversion of xor_xy
module B (
    input  wire xor_xy,
    output wire z
);
    assign z = ~xor_xy;
endmodule

// Top-level module:
// Instantiates two A and two B modules,
// all with inputs x and shared xor_xy,
// computes final output z = (A0 | B0) XOR (A1 & B1)
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy = x ^ y;

    // Outputs of first pair (A0 and B0)
    wire a0_out;
    wire b0_out;

    // Outputs of second pair (A1 and B1)
    wire a1_out;
    wire b1_out;

    // Instantiate first A module
    A a0 (
        .x(x),
        .xor_xy(xor_xy),
        .z(a0_out)
    );

    // Instantiate first B module
    B b0 (
        .xor_xy(xor_xy),
        .z(b0_out)
    );

    // Instantiate second A module
    A a1 (
        .x(x),
        .xor_xy(xor_xy),
        .z(a1_out)
    );

    // Instantiate second B module
    B b1 (
        .xor_xy(xor_xy),
        .z(b1_out)
    );

    // Combine outputs as per original spec
    wire or_out = a0_out | b0_out;
    wire and_out = a1_out & b1_out;

    // Final output
    assign z = or_out ^ and_out;
endmodule