module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Internal extended result (N+1 bits to detect overflow)
    wire signed [N:0] extended_res = a + b;

    // Overflow occurs when sign bits don't match and result exceeds N-bit range
    wire overflow = (extended_res[N] != extended_res[N-1]) && 
                   (a[N-1] == b[N-1]);

    // Final result with overflow handling (saturate to max/min)
    assign c = overflow ? 
              (a[N-1] ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}}) :
              extended_res[N-1:0];

endmodule