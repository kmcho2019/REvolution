// Module A: z = (x ^ y) & x
module A (
    input  wire x,
    input  wire y,
    input  wire xor_xy,
    output wire z
);
    assign z = xor_xy & x;
endmodule

// Module B: z = ~(x ^ y)
module B (
    input  wire inv_xor_xy,
    output wire z
);
    assign z = inv_xor_xy;
endmodule

// Top-level module
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy;
    wire inv_xor_xy;

    // Precompute x ^ y and its inversion for sharing
    assign xor_xy = x ^ y;
    assign inv_xor_xy = ~xor_xy;

    // Outputs from first pair (A0 and B0)
    wire a0_out;
    wire b0_out;

    // Outputs from second pair (A1 and B1)
    wire a1_out;
    wire b1_out;

    // Instantiate first A and B modules
    A a0_inst (
        .x(x),
        .y(y),
        .xor_xy(xor_xy),
        .z(a0_out)
    );

    B b0_inst (
        .inv_xor_xy(inv_xor_xy),
        .z(b0_out)
    );

    // Instantiate second A and B modules
    A a1_inst (
        .x(x),
        .y(y),
        .xor_xy(xor_xy),
        .z(a1_out)
    );

    B b1_inst (
        .inv_xor_xy(inv_xor_xy),
        .z(b1_out)
    );

    // OR gate combining first pair outputs
    wire or_out = a0_out | b0_out;

    // AND gate combining second pair outputs
    wire and_out = a1_out & b1_out;

    // Final output z is XOR of or_out and and_out
    assign z = or_out ^ and_out;
endmodule