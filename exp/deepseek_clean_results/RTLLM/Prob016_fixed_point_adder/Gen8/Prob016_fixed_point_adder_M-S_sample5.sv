module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (documentation only)
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Direct fixed-point addition using 2's complement arithmetic
    // Let the natural overflow/wrap-around behavior handle all cases
    assign c = a + b;

endmodule