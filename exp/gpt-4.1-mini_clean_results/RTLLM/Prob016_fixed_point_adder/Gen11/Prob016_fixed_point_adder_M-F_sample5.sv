module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision), default = 8
    parameter integer N = 16          // Total number of bits including sign, default = 16
)(
    input  wire [N-1:0] a,            // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,            // Fixed-point input operand B (two's complement)
    output wire [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Extract sign bits (MSB)
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Extract magnitudes (absolute values) of a and b (N-1 bits)
    // If sign bit is 1, number is negative, so take two's complement to get magnitude
    wire [N-2:0] mag_a = sign_a ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] mag_b = sign_b ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Compare magnitudes to determine which is larger (used when signs differ)
    wire a_greater_eq_b = (mag_a >= mag_b);

    // Sum of magnitudes when signs are the same (with carry to handle overflow)
    wire [N-1:0] mag_sum = {1'b0, mag_a} + {1'b0, mag_b};

    // Difference of magnitudes when signs differ; subtract smaller from larger magnitude
    wire [N-1:0] mag_diff = a_greater_eq_b ? 
                           ({1'b0, mag_a} - {1'b0, mag_b}) : 
                           ({1'b0, mag_b} - {1'b0, mag_a});

    // Determine result sign:
    // - If inputs have same sign, result sign is same as inputs
    // - If signs differ, result sign is sign of operand with larger magnitude
    wire res_sign = (sign_a == sign_b) ? sign_a : (a_greater_eq_b ? sign_a : sign_b);

    // Result magnitude depends on sign relation:
    // - Same sign: sum of magnitudes (take lower N-1 bits)
    // - Different signs: difference of magnitudes (lower N-1 bits)
    wire [N-2:0] res_mag = (sign_a == sign_b) ? mag_sum[N-2:0] : mag_diff[N-2:0];

    // If magnitude is zero, result is positive zero (sign=0)
    wire zero_mag = (res_mag == { (N-1){1'b0} });
    wire final_sign = zero_mag ? 1'b0 : res_sign;

    // Construct two's complement output:
    // - If sign is 1 (negative), output is two's complement of magnitude
    // - Else output is positive magnitude with sign bit 0
    assign c = final_sign ? {1'b1, (~res_mag + 1'b1)} : {1'b0, res_mag};

endmodule