module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal signals
    wire [N:0] sum;  // Extra bit for carry-out
    wire overflow;

    // Perform 2's complement addition directly
    assign sum = {a[N-1], a} + {b[N-1], b};

    // Overflow occurs when:
    // 1. Adding two positives gives negative (carry-in != carry-out)
    // 2. Adding two negatives gives positive
    assign overflow = (~a[N-1] & ~b[N-1] & sum[N-1]) |  // Positive overflow
                     (a[N-1] & b[N-1] & ~sum[N-1]);     // Negative overflow

    // Result selection with saturation
    assign c = overflow ? 
               (sum[N] ? {1'b0, {(N-1){1'b1}}} :  // Positive saturation
                         {1'b1, {(N-1){1'b0}}} :  // Negative saturation
               sum[N-1:0];                       // Normal result

endmodule