`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // total bits (integer + fractional)
    parameter integer Q = 8    // fractional bits
)(
    input  wire [N-1:0] a,    // fixed-point inputs (unsigned here, sign handled manually)
    input  wire [N-1:0] b,
    output reg  [N-1:0] c     // fixed-point output
);

    // Internal signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitudes (clear sign bit)
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Convert magnitudes to a unified fixed-point magnitude with sign stripped
    // We will perform arithmetic on magnitudes extended to N bits with leading zero for sign
    wire [N-1:0] a_abs = {1'b0, a_mag};
    wire [N-1:0] b_abs = {1'b0, b_mag};

    reg [N:0] res_mag;   // one bit wider to hold addition/subtraction carry/borrow
    reg res_sign;
    reg [N-1:0] res;     // combined result with sign bit

    // Compare magnitudes to determine magnitude ordering
    wire a_greater_eq_b = (a_abs >= b_abs);

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes
            if (a_greater_eq_b) begin
                // a_mag >= b_mag, result sign same as inputs
                res_mag = a_abs - b_abs;
                res_sign = a_sign;
            end else begin
                // a_mag < b_mag, result sign inverted, magnitude = b_mag - a_mag
                res_mag = b_abs - a_abs;
                res_sign = ~a_sign;
            end
        end else begin
            // Different signs: add magnitudes
            res_mag = a_abs + b_abs;
            // Sign equals the sign of the input with larger magnitude
            if (a_greater_eq_b) begin
                res_sign = a_sign;
            end else begin
                res_sign = b_sign;
            end
        end

        // Handle zero result explicitly: if magnitude zero, sign forced to 0
        if (res_mag == 0) begin
            res_sign = 1'b0;
        end

        // Build final result: sign bit + lower N-1 bits of magnitude
        // If the magnitude does not fit, saturate by clipping top bits (optional)
        // Here just truncate excess MSB if any
        res = {res_sign, res_mag[N-2:0]};
        c = res;
    end

endmodule