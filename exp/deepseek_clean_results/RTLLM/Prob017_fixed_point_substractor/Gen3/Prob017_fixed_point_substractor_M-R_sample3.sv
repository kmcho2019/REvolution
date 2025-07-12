module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Internal signals
    wire signed [N-1:0] raw_diff;
    wire overflow_pos, overflow_neg;
    wire is_zero;

    // Direct subtraction
    assign raw_diff = a - b;

    // Overflow detection (combined conditions)
    assign overflow_pos = (~a[N-1] & b[N-1] & raw_diff[N-1]);  // a+ - b- = should be +
    assign overflow_neg = (a[N-1] & ~b[N-1] & ~raw_diff[N-1]); // a- - b+ = should be -
    assign is_zero = (raw_diff == 0);

    // Output with saturation and zero handling
    assign c = is_zero ? 0 : 
              (overflow_pos ? {1'b0, {(N-1){1'b1}}} : 
              (overflow_neg ? {1'b1, {(N-1){1'b0}}} : raw_diff));

endmodule