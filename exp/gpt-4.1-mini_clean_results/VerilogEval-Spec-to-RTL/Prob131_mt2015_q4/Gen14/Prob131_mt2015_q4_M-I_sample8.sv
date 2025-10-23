// Module A: z = (x XOR y) AND x
// Inputs: x, xor_xy (precomputed x ^ y)
module A (
    input  wire x,
    input  wire xor_xy,
    output wire z
);
    assign z = xor_xy & x;
endmodule

// Module B: z = ~(x XOR y)
// Now simplified to just output the precomputed inverted xor_xy input
module B (
    input  wire inv_xor_xy,
    output wire z
);
    assign z = inv_xor_xy;
endmodule

// Wrapper module PairOR:
// Instantiates one A and one B submodule with shared xor_xy and inv_xor_xy,
// outputs OR of A.z and B.z
module PairOR (
    input  wire x,
    input  wire xor_xy,
    input  wire inv_xor_xy,
    output wire z
);
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

    assign z = a_out | b_out;
endmodule

// Wrapper module PairAND:
// Instantiates one A and one B submodule with shared xor_xy and inv_xor_xy,
// outputs AND of A.z and B.z
module PairAND (
    input  wire x,
    input  wire xor_xy,
    input  wire inv_xor_xy,
    output wire z
);
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

    assign z = a_out & b_out;
endmodule

// Top-level module:
// Instantiates PairOR and PairAND with inputs x,y,
// shares xor_xy and its inversion inv_xor_xy to optimize logic,
// output z = XOR of outputs from PairOR and PairAND
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy;
    wire inv_xor_xy;

    // Shared computation of xor_xy and its inversion
    assign xor_xy = x ^ y;
    assign inv_xor_xy = ~xor_xy;

    wire or_pair_out;
    wire and_pair_out;

    PairOR  or_pair (
        .x(x),
        .xor_xy(xor_xy),
        .inv_xor_xy(inv_xor_xy),
        .z(or_pair_out)
    );

    PairAND and_pair (
        .x(x),
        .xor_xy(xor_xy),
        .inv_xor_xy(inv_xor_xy),
        .z(and_pair_out)
    );

    assign z = or_pair_out ^ and_pair_out;
endmodule