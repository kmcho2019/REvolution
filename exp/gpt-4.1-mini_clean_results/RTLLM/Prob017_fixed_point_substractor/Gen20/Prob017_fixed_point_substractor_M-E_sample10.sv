`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // total bits including sign bit
    parameter integer Q = 8    // fractional bits
)(
    input  wire [N-1:0] a,     // fixed-point input operand (signed, two's complement)
    input  wire [N-1:0] b,     // fixed-point input operand (signed, two's complement)
    output reg  [N-1:0] c      // fixed-point subtraction result (signed, two's complement)
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute magnitude (absolute value) of a and b
    wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;  // if sign==1 (neg), magnitude = two's complement
    wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;

    // Intermediate variables
    reg [N-1:0] mag_result;     // magnitude result
    reg        res_sign;        // result sign bit

    // Compare magnitudes
    wire a_gte_b = (a_mag >= b_mag);

    always @(*) begin
        // Default assign
        mag_result = 0;
        res_sign = 0;

        if (a_sign == b_sign) begin
            // Same sign subtraction: |a| - |b|
            if (a_gte_b) begin
                mag_result = a_mag - b_mag;
                res_sign = a_sign; // result sign same as inputs
            end else begin
                mag_result = b_mag - a_mag;
                res_sign = a_sign; // same sign, so result sign same as inputs (both same sign)
                // Note: subtraction is b_mag - a_mag but sign remains a_sign since both have same sign
                // However, mathematically, if a < b, result sign is sign of inputs
                // But since result magnitude is (b_mag - a_mag), need to flip sign if negative?
                // Actually in same sign subtraction, c = a - b; so if a < b, c negative; so result sign = sign of inputs
                // So when a < b and sign is 1 (neg), result sign is 1; when sign is 0, result sign is 0
                // Thus, result sign remains input sign
                // So res_sign already set correctly
            end
        end else begin
            // Different sign subtraction: a - b = a + (-b)
            // Equivalent to adding magnitudes
            mag_result = a_mag + b_mag;
            // Result sign depends on which operand magnitude is larger
            if (a_gte_b)
                res_sign = a_sign; // result sign same as 'a' (larger magnitude)
            else
                res_sign = b_sign; // result sign same as 'b'
        end

        // If result magnitude is zero, force sign bit to 0
        if (mag_result == 0)
            res_sign = 1'b0;

        // Reassemble two's complement output from sign and magnitude
        if (res_sign == 1'b0) begin
            // positive number: sign=0, magnitude as is
            c = mag_result;
        end else begin
            // negative number: two's complement of magnitude
            c = (~mag_result) + 1'b1;
        end
    end

endmodule