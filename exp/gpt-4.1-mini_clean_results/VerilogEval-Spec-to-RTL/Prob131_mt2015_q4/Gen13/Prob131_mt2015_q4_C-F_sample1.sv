// Module A: z = (x XOR y) & x
// Modified to accept precomputed xor_xy
module A (
    input  wire x,
    input  wire xor_xy,
    output wire z
);
    assign z = xor_xy & x;
endmodule

// Module B: z = ~xor_xy
// Accept precomputed xor_xy_inv to share inversion
module B (
    input  wire xor_xy_inv,
    output wire z
);
    assign z = xor_xy_inv;
endmodule

// Top-level module
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy;
    wire xor_xy_inv;

    // Compute XOR once and invert once for sharing
    assign xor_xy = x ^ y;
    assign xor_xy_inv = ~xor_xy;

    // Wires for first pair (OR gate)
    wire a1_z;
    wire b1_z;
    wire or_out;

    // Wires for second pair (AND gate)
    wire a2_z;
    wire b2_z;
    wire and_out;

    // Instantiate first A and B modules
    A A1 (
        .x(x),
        .xor_xy(xor_xy),
        .z(a1_z)
    );

    B B1 (
        .xor_xy_inv(xor_xy_inv),
        .z(b1_z)
    );

    assign or_out = a1_z | b1_z;

    // Instantiate second A and B modules
    A A2 (
        .x(x),
        .xor_xy(xor_xy),
        .z(a2_z)
    );

    B B2 (
        .xor_xy_inv(xor_xy_inv),
        .z(b2_z)
    );

    assign and_out = a2_z & b2_z;

    // Final output: XOR of or_out and and_out
    assign z = or_out ^ and_out;
endmodule