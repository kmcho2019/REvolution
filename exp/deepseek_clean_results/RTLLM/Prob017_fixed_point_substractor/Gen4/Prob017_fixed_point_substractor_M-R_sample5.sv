module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    wire signed [N-1:0] raw_result = a - b;
    wire is_zero = (raw_result == 0);
    wire same_sign = (a[N-1] == b[N-1]);
    
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} :  // Explicit zero handling
               same_sign ? {a[N-1], raw_result[N-2:0]} :  // Same sign case
               (a > b) ? {1'b0, raw_result[N-2:0]} :  // Different signs, a > b
               {1'b1, raw_result[N-2:0]};  // Different signs, b > a

endmodule