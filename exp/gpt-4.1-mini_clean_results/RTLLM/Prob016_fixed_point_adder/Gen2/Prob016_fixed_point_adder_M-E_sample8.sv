module fixed_point_adder #(
    parameter Q = 8,        // Number of fractional bits
    parameter N = 16        // Total number of bits (including sign)
)(
    input  wire signed [N-1:0] a,   // Signed fixed-point input a
    input  wire signed [N-1:0] b,   // Signed fixed-point input b
    output wire signed [N-1:0] c    // Signed fixed-point output c
);

    // Intermediate signed result with one extra bit to detect overflow if desired
    wire signed [N:0] sum_ext;

    // Perform signed addition with extended width to capture overflow bit
    assign sum_ext = a + b;

    // Output result truncated to N bits (wrap-around on overflow)
    assign c = sum_ext[N-1:0];

endmodule