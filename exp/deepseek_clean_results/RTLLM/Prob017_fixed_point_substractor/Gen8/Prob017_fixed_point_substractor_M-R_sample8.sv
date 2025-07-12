module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c,
    output wire overflow       // Optional overflow flag
);

    // Internal signals
    wire signed [N-1:0] b_neg = -b;
    wire same_sign = ~(a[N-1] ^ b[N-1]);
    
    // Main subtraction logic
    wire signed [N-1:0] same_sign_result = a - b;
    wire signed [N-1:0] diff_sign_result = a + b_neg;
    
    // Result selection
    assign c = same_sign ? same_sign_result : diff_sign_result;
    
    // Overflow detection (optional)
    assign overflow = (same_sign && (a[N-1] != c[N-1])) ? 1'b1 : 1'b0;

endmodule