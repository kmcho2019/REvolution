`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,    // Total bits (including sign)
    parameter integer Q = 8      // Fractional bits
)(
    input  wire [N-1:0] a,       // Fixed-point input a (signed two's complement)
    input  wire [N-1:0] b,       // Fixed-point input b (signed two's complement)
    output reg  [N-1:0] c        // Fixed-point output c = a - b
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values of a and b as unsigned
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Internal magnitude result width: N-1 bits (magnitude only)
    reg [N-2:0] mag_res;

    // Result sign bit
    reg res_sign;

    // Internal register to hold complete result (including sign)
    reg [N-1:0] res;

    // Compare magnitudes (unsigned)
    wire a_greater_eq_b = (a_mag >= b_mag);

    // Main combinational logic block
    always @* begin
        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes
            if (a_greater_eq_b) begin
                mag_res = a_mag - b_mag;
                res_sign = a_sign;  // Result sign same as inputs
            end else begin
                mag_res = b_mag - a_mag;
                res_sign = a_sign;  // Same input sign, so result sign is input sign (same)
                // but magnitude subtraction swapped => should negate sign?
                // Actually for same sign subtraction, larger minus smaller magnitude,
                // sign is the sign of the larger magnitude operand (which is b if b_mag > a_mag)
                // So if b_mag > a_mag, sign = a_sign (both same), but sign should be same as inputs,
                // but result magnitude swapped, so sign follows bigger magnitude input. Fix:
                // Actually sign = a_sign if a_mag >= b_mag else b_sign (which equals a_sign here)
                // Since a_sign == b_sign, sign remains the same.
                // So no change needed.
            end
        end else begin
            // Different signs: add magnitudes
            mag_res = a_mag + b_mag;
            // Result sign = sign of operand with larger magnitude
            if (a_greater_eq_b)
                res_sign = a_sign;
            else
                res_sign = b_sign;
        end

        // Compose full result: sign + magnitude
        // Handle zero result: if mag_res == 0, force sign = 0
        if (mag_res == 0) begin
            res = {1'b0, {(N-1){1'b0}}};
        end else begin
            // If result sign is 1 (negative), convert magnitude back to two's complement negative
            // Two's complement form of negative magnitude: ~mag + 1
            if (res_sign == 1'b0) begin
                // Positive result: sign bit 0, magnitude as is
                res = {1'b0, mag_res};
            end else begin
                // Negative result: sign bit 1, magnitude negated by two's complement
                res = {1'b1, (~mag_res + 1'b1)};
            end
        end
    end

    // Output assignment
    always @* begin
        c = res;
    end

endmodule


// Testbench for verification
module tb_fixed_point_subtractor;

    parameter integer N = 16;
    parameter integer Q = 8;

    reg  [N-1:0] a, b;
    wire [N-1:0] c;

    fixed_point_subtractor #(.N(N), .Q(Q)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    // Convert fixed-point two's complement to real number
    function real to_real(input [N-1:0] val);
        reg signed [N-1:0] signed_val;
        begin
            signed_val = val;
            to_real = signed_val / (2.0 ** Q);
        end
    endfunction

    // Convert real number to fixed-point two's complement
    function [N-1:0] to_fixed(input real val);
        reg signed [N-1:0] temp;
        begin
            temp = $rtoi(val * (2.0 ** Q));
            to_fixed = temp;
        end
    endfunction

    initial begin
        $display("Time | a (real)    | b (real)    | c (real)     | Expected c");
        $display("---------------------------------------------------------------");

        a = to_fixed( 1.5);   b = to_fixed( 0.5);   #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 1.5 - 0.5);

        a = to_fixed(-2.25);  b = to_fixed( 1.25);  #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), -2.25 - 1.25);

        a = to_fixed( 0.75);  b = to_fixed(-0.75);  #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.75 - (-0.75));

        a = to_fixed(-1.0);   b = to_fixed(-1.0);   #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        a = to_fixed( 0.0);   b = to_fixed( 0.0);   #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        a = to_fixed( 127.5); b = to_fixed(-128.0); #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 127.5 - (-128.0));

        a = to_fixed(-64.125); b = to_fixed(64.125); #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), -64.125 - 64.125);

        a = to_fixed(0.0); b = to_fixed(0.125); #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.0 - 0.125);

        // Edge case: result zero with different signs
        a = to_fixed(0.5); b = to_fixed(0.5); #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        $finish;
    end

endmodule