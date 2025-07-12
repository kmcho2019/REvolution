// Pair module computes:
// Inputs: x, y
// sel = 0 => output = ((x^y) & x) | ~(x^y)
// sel = 1 => output = ((x^y) & x) & ~(x^y)
module Pair (
    input  wire x,
    input  wire y,
    input  wire sel,  // 0: OR, 1: AND
    output wire z
);
    wire xor_xy;
    wire a_out;
    wire b_out;

    assign xor_xy = x ^ y;
    assign a_out  = xor_xy & x;
    assign b_out  = ~xor_xy;

    assign z = sel ? (a_out & b_out) : (a_out | b_out);
endmodule

// Top-level module:
// Instantiates two Pair modules:
// - pair_or with sel=0 (OR)
// - pair_and with sel=1 (AND)
// Output z = pair_or_out ^ pair_and_out
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire pair_or_out;
    wire pair_and_out;

    Pair pair_or (
        .x(x),
        .y(y),
        .sel(1'b0),
        .z(pair_or_out)
    );

    Pair pair_and (
        .x(x),
        .y(y),
        .sel(1'b1),
        .z(pair_and_out)
    );

    assign z = pair_or_out ^ pair_and_out;
endmodule