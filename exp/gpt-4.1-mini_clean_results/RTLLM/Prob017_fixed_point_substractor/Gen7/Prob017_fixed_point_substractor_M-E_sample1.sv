`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,   // Total bits (sign + integer + fractional)
    parameter integer Q = 8     // Number of fractional bits
)(
    input  wire [N-1:0] a,      // N-bit fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,      // N-bit fixed-point input operand b (two's complement)
    output reg  [N-1:0] c       // N-bit fixed-point output c = a - b (two's complement)
);

    // Internal registers for sign and magnitude
    reg a_sign;
    reg b_sign;

    reg [N-2:0] a_mag; // Magnitude excluding sign bit
    reg [N-2:0] b_mag;

    reg res_sign;
    reg [N-2:0] res_mag;

    reg [N-1:0] res_twos_complement;

    // Function to convert two's complement to magnitude and sign
    function void twos_to_sign_mag(
        input  [N-1:0] in,
        output reg     sign,
        output reg [N-2:0] mag
    );
        begin
            sign = in[N-1];
            if (sign == 1'b0) begin
                mag = in[N-2:0];
            end else begin
                // For negative number, magnitude = two's complement
                mag = (~in[N-2:0]) + 1'b1;
            end
        end
    endfunction

    // Function to convert magnitude and sign back to two's complement
    function [N-1:0] sign_mag_to_twos;
        input sign_in;
        input [N-2:0] mag_in;
        begin
            if (mag_in == 0) begin
                // Zero always positive sign
                sign_mag_to_twos = {1'b0, {(N-1){1'b0}}};
            end else if (sign_in == 1'b0) begin
                // Positive number
                sign_mag_to_twos = {1'b0, mag_in};
            end else begin
                // Negative number: two's complement of magnitude
                sign_mag_to_twos = {1'b1, (~mag_in + 1'b1)};
            end
        end
    endfunction

    // Combinational block to perform fixed-point subtraction as per specification
    always @(*) begin
        // Convert inputs to sign/magnitude
        twos_to_sign_mag(a, a_sign, a_mag);
        twos_to_sign_mag(b, b_sign, b_mag);

        if (a_sign == b_sign) begin
            // Same sign: subtraction of magnitudes
            if (a_mag >= b_mag) begin
                res_mag = a_mag - b_mag;
                res_sign = a_sign; // Same as inputs
            end else begin
                res_mag = b_mag - a_mag;
                // Result sign same as inputs (same sign), but magnitude flipped because subtraction negative
                // Since a < b and same sign, result sign matches inputs' sign (which are same).
                // Per problem statement: sign of result same as inputs.
                // But physically subtracting smaller from bigger flips sign: so to respect spec,
                // swap sign to a_sign (inputs' sign)
                // On careful reading, "When signs same, subtract magnitude, sign of result is same as inputs"
                // So even if a_mag < b_mag, sign same as inputs.
                // But magnitude is positive difference, so no sign flip. So result sign = a_sign
                // So keep sign as a_sign regardless
                res_sign = a_sign;
            end
        end else begin
            // Different signs: add magnitudes
            res_mag = a_mag + b_mag;
            // Result sign depends on magnitude comparison of a and b (absolute values)
            if (a_mag > b_mag) begin
                res_sign = a_sign;
            end else if (b_mag > a_mag) begin
                res_sign = b_sign;
            end else begin
                // Equal magnitude => zero result (sign zeroed)
                res_sign = 1'b0;
                res_mag = 0;
            end
        end

        // Handle zero result sign bit explicitly
        if (res_mag == 0) begin
            res_sign = 1'b0;
        end

        // Convert back to two's complement fixed-point
        res_twos_complement = sign_mag_to_twos(res_sign, res_mag);

        c = res_twos_complement;
    end

endmodule


// Testbench to validate fixed_point_subtractor
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

    // Function to convert fixed-point two's complement to real
    function real fixed_to_real;
        input [N-1:0] val;
        reg signed [N-1:0] sval;
        begin
            sval = val;
            fixed_to_real = sval / (2.0 ** Q);
        end
    endfunction

    initial begin
        $display("Time | a (real)     | b (real)     | c (real)      | Expected c");
        $display("--------------------------------------------------------------");

        // Test cases: format a, b, expected result
        // Using fixed-point representation Q=8: multiply real value by 2^Q

        a = 16'sd384;   b = 16'sd128;   #5;  // 1.5 - 0.5 = 1.0
        $display("%4t | %12f | %12f | %13f | %10f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 1.5-0.5);

        a = -16'sd576;  b = 16'sd320;   #5;  // -2.25 - 1.25 = -3.5
        $display("%4t | %12f | %12f | %13f | %10f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -2.25-1.25);

        a = 16'sd192;   b = -16'sd192;  #5;  // 0.75 - (-0.75) = 1.5
        $display("%4t | %12f | %12f | %13f | %10f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.75-(-0.75));

        a = -16'sd256;  b = -16'sd256;  #5;  // -1.0 - (-1.0) = 0.0
        $display("%4t | %12f | %12f | %13f | %10f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        a = 16'sd0;     b = 16'sd0;     #5;  // 0.0 - 0.0 = 0.0
        $display("%4t | %12f | %12f | %13f | %10f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        a = 16'sd32767; b = -16'sd32768; #5; // Max positive - max negative (overflow potential)
        $display("%4t | %12f | %12f | %13f | %10f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 
                 (32767/(2.0**Q))-(-32768/(2.0**Q)));

        a = -16'sd512;  b = 16'sd256;   #5;  // -2.0 - 1.0 = -3.0
        $display("%4t | %12f | %12f | %13f | %10f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -2.0-1.0);

        a = 16'sd256;   b = -16'sd512;  #5;  // 1.0 - (-2.0) = 3.0
        $display("%4t | %12f | %12f | %13f | %10f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 1.0-(-2.0));

        // Zero result with different sign inputs but equal magnitude
        a = 16'sd256;   b = 16'sd256;   #5;  // 1.0 - 1.0 = 0.0
        $display("%4t | %12f | %12f | %13f | %10f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        $finish;
    end

endmodule