// Module A: z = (x XOR y) AND x
// We modify A to accept precomputed xor_xy input for optimization
module A (
    input  wire x,
    input  wire xor_xy,
    output wire z
);
    assign z = xor_xy & x;
endmodule

// Module B: z = ~(x XOR y)
// We modify B to accept precomputed xor_xy input for optimization
module B (
    input  wire xor_xy,
    output wire z
);
    assign z = ~xor_xy;
endmodule

// Wrapper module PairOR:
// Instantiates one A and one B submodule with shared xor_xy,
// outputs OR of A.z and B.z
module PairOR (
    input  wire x,
    input  wire xor_xy,
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
        .xor_xy(xor_xy),
        .z(b_out)
    );

    assign z = a_out | b_out;
endmodule

// Wrapper module PairAND:
// Instantiates one A and one B submodule with shared xor_xy,
// outputs AND of A.z and B.z
module PairAND (
    input  wire x,
    input  wire xor_xy,
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
        .xor_xy(xor_xy),
        .z(b_out)
    );

    assign z = a_out & b_out;
endmodule

// Top-level module:
// Instantiates PairOR and PairAND with inputs x,y,
// shares the xor_xy intermediate signal to optimize logic,
// output z = XOR of outputs from PairOR and PairAND
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy;

    // Shared computation of xor_xy signal
    assign xor_xy = x ^ y;

    wire or_pair_out;
    wire and_pair_out;

    PairOR  or_pair (
        .x(x),
        .xor_xy(xor_xy),
        .z(or_pair_out)
    );

    PairAND and_pair (
        .x(x),
        .xor_xy(xor_xy),
        .z(and_pair_out)
    );

    assign z = or_pair_out ^ and_pair_out;
endmodule