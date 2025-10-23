module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Direct subtraction with implicit two's complement handling
    // Zero result forces sign bit to 0 when all bits are zero
    assign c = (a - b == 0) ? 0 : (a - b);

endmodule