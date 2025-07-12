// Module A: z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = ~(x XOR y)
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Wrapper module PairOR:
// Instantiates one A and one B submodule with inputs x,y,
// outputs OR of A.z and B.z
module PairOR (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a_out;
    wire b_out;

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

    assign z = a_out | b_out;
endmodule

// Wrapper module PairAND:
// Instantiates one A and one B submodule with inputs x,y,
// outputs AND of A.z and B.z
module PairAND (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a_out;
    wire b_out;

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

    assign z = a_out & b_out;
endmodule

// Top-level module:
// Instantiates PairOR and PairAND with inputs x,y
// Output z = XOR of outputs from PairOR and PairAND
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire or_pair_out;
    wire and_pair_out;

    PairOR  or_pair (
        .x(x),
        .y(y),
        .z(or_pair_out)
    );

    PairAND and_pair (
        .x(x),
        .y(y),
        .z(and_pair_out)
    );

    assign z = or_pair_out ^ and_pair_out;
endmodule