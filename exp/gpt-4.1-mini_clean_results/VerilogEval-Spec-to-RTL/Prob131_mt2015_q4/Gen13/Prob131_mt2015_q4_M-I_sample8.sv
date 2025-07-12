// Module A: z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = XNOR of x and y (z = ~(x ^ y))
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Top-level module optimized for PPA by sharing common XOR computation
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy;
    wire a_out;
    wire b_out;
    wire or_out;
    wire and_out;

    // Compute xor_xy once and share
    assign xor_xy = x ^ y;

    // A_out = (x ^ y) & x
    assign a_out = xor_xy & x;

    // B_out = ~(x ^ y)
    assign b_out = ~xor_xy;

    // OR and AND of A_out and B_out
    assign or_out  = a_out | b_out;
    assign and_out = a_out & b_out;

    // Final output is XOR of OR and AND results
    assign z = or_out ^ and_out;
endmodule