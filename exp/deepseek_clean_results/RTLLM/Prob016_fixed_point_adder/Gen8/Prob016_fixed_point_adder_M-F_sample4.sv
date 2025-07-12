module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal signals
    wire [N-1:0] abs_a, abs_b;
    wire [N-1:0] sum, diff;
    wire a_sign, b_sign;
    wire sign_diff;
    wire [N-1:0] unsigned_res;
    wire res_sign;
    wire overflow;

    // Extract signs
    assign a_sign = a[N-1];
    assign b_sign = b[N-1];
    assign sign_diff = a_sign ^ b_sign;

    // Absolute values (discard sign bit)
    assign abs_a = a_sign ? ~a + 1'b1 : a;
    assign abs_b = b_sign ? ~b + 1'b1 : b;

    // Arithmetic operations
    assign sum = abs_a + abs_b;
    assign diff = (abs_a > abs_b) ? (abs_a - abs_b) : (abs_b - abs_a);

    // Result selection
    assign unsigned_res = sign_diff ? diff : sum;
    assign res_sign = sign_diff ? 
                     ((abs_a > abs_b) ? a_sign : b_sign) : 
                     a_sign;  // same sign as inputs

    // Overflow detection (only for same-sign addition)
    assign overflow = ~sign_diff & (sum[N-1] != a_sign);

    // Final result with overflow handling
    assign c = overflow ? 
               (a_sign ? {1'b1, {(N-1){1'b0}}} :  // Negative saturation
                         {1'b0, {(N-1){1'b1}}}) : // Positive saturation
               {res_sign, unsigned_res[N-2:0]};   // Normal result

endmodule