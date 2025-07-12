module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits (precision)
    parameter integer N = 16     // Total number of bits including sign
)(
    input  wire [N-1:0] a,       // Fixed-point input operand A
    input  wire [N-1:0] b,       // Fixed-point input operand B
    output wire [N-1:0] c        // Fixed-point addition result
);

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Compute absolute values (two's complement if negative)
    wire [N-1:0] abs_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] abs_b = sign_b ? (~b + 1'b1) : b;

    // Compare absolute values
    wire a_gte_b = (abs_a >= abs_b);

    // Sum and difference of absolute values (width N+1 for overflow detection)
    wire [N:0] abs_sum = {1'b0, abs_a} + {1'b0, abs_b};
    wire [N:0] abs_diff = a_gte_b ? ({1'b0, abs_a} - {1'b0, abs_b}) : ({1'b0, abs_b} - {1'b0, abs_a});

    // Result sign and magnitude
    // If signs are equal, result sign = sign_a = sign_b, magnitude = abs_sum
    // Else, result sign = sign of operand with larger abs value, magnitude = abs_diff
    wire res_sign = (sign_a == sign_b) ? sign_a : (a_gte_b ? sign_a : sign_b);

    wire [N-1:0] res_mag = (sign_a == sign_b) ? abs_sum[N-1:0] : abs_diff[N-1:0];

    // Handle zero case for subtraction result: if magnitude == 0, sign should be 0 (positive)
    wire zero_mag = (res_mag == {N{1'b0}});
    wire final_sign = zero_mag ? 1'b0 : res_sign;

    // Compose final result in two's complement form
    wire [N-1:0] res = final_sign ? (~res_mag + 1'b1) : res_mag;

    assign c = res;

endmodule