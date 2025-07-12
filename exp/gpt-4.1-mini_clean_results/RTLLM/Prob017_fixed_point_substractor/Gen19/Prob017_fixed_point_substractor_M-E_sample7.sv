`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign bit
    parameter integer Q = 8    // Fractional bits (not used in hardware logic)
)(
    input  wire [N-1:0] a,     // Fixed-point input operand a
    input  wire [N-1:0] b,     // Fixed-point input operand b
    output reg  [N-1:0] c      // Fixed-point subtraction result output
);

    // Internal registers for sign and magnitude
    reg a_sign, b_sign, res_sign;
    reg [N-2:0] a_mag, b_mag;    // Magnitude excludes sign bit
    reg [N-2:0] res_mag;
    reg [N-1:0] res;             // Full result register: sign + magnitude

    // Combinational logic for subtraction
    always @* begin
        // Extract sign bits (MSB)
        a_sign = a[N-1];
        b_sign = b[N-1];

        // Extract magnitude (absolute value)
        a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
        b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes
            if (a_mag >= b_mag) begin
                res_mag = a_mag - b_mag;
                res_sign = a_sign;  // Same sign as inputs
            end else begin
                res_mag = b_mag - a_mag;
                res_sign = a_sign;  // Same sign as inputs (per specification)
            end
        end else begin
            // Different signs: add magnitudes
            res_mag = a_mag + b_mag;
            // Determine sign of result:
            // If a positive and b negative: res_sign = 0 (positive)
            // If a negative and b positive: res_sign = 1 (negative)
            if (a_sign == 1'b0 && b_sign == 1'b1) begin
                // a positive, b negative
                // Compare magnitudes for sign
                if (a_mag >= b_mag) 
                    res_sign = 1'b0; // positive
                else
                    res_sign = 1'b1; // negative
            end else begin
                // a negative, b positive
                if (a_mag >= b_mag)
                    res_sign = 1'b1; // negative
                else
                    res_sign = 1'b0; // positive
            end
        end

        // Handle zero result: if magnitude zero, set sign to zero
        if (res_mag == 0)
            res_sign = 1'b0;

        // Compose final result from sign and magnitude (two's complement)
        if (res_sign == 1'b0) begin
            // positive number: sign=0, magnitude as is
            res = {1'b0, res_mag};
        end else begin
            // negative number: two's complement of magnitude
            res = {1'b1, (~res_mag + 1'b1)};
        end

        c = res;
    end

endmodule