`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign)
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,     // Fixed-point input a (two's complement)
    input  wire [N-1:0] b,     // Fixed-point input b (two's complement)
    output reg  [N-1:0] c      // Fixed-point output c = a - b (two's complement)
);

    // Internal signals
    reg a_sign;
    reg b_sign;

    reg [N-2:0] a_mag;  // Magnitude bits (abs), exclude sign bit
    reg [N-2:0] b_mag;

    reg [N-2:0] res_mag;    // Result magnitude (unsigned)
    reg        res_sign;    // Result sign

    // Temporary variables for magnitude calculation
    reg [N-1:0] a_abs;
    reg [N-1:0] b_abs;

    integer i;

    // Function to get absolute value of two's complement number
    function [N-1:0] abs_twos_complement;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1) // Negative
                abs_twos_complement = (~val + 1'b1);
            else
                abs_twos_complement = val;
        end
    endfunction

    always @(*) begin
        // Extract sign bits
        a_sign = a[N-1];
        b_sign = b[N-1];

        // Calculate magnitudes (absolute values)
        a_abs = abs_twos_complement(a);
        b_abs = abs_twos_complement(b);

        // Magnitudes without sign bit
        a_mag = a_abs[N-2:0];
        b_mag = b_abs[N-2:0];

        // Compute the difference: a - b
        // Based on sign conditions:

        if (a_sign == b_sign) begin
            // Same sign: res = a_mag - b_mag
            if (a_mag >= b_mag) begin
                res_mag = a_mag - b_mag;
                res_sign = a_sign;  // same sign as inputs
            end else begin
                res_mag = b_mag - a_mag;
                res_sign = ~a_sign; // opposite sign since a_mag < b_mag
            end
        end else begin
            // Different sign: res = a_mag + b_mag
            res_mag = a_mag + b_mag;

            // Determine sign of result based on which magnitude is greater
            // If a positive, b negative: res_sign = sign of larger magnitude
            // If a negative, b positive: same logic

            if (a_mag > b_mag) begin
                res_sign = a_sign;
            end else if (b_mag > a_mag) begin
                res_sign = b_sign; // Note b_sign is sign of b, which differs from a_sign here
            end else begin
                // Equal magnitudes: result zero, sign zero
                res_sign = 1'b0;
            end
        end

        // Handle zero result explicitly:
        if (res_mag == 0) begin
            res_sign = 1'b0;  // zero sign bit explicitly cleared
        end

        // Assemble final result two's complement value:
        // If res_sign == 0, result positive: direct magnitude with sign bit 0
        // If res_sign == 1, result negative: two's complement of magnitude

        if (res_sign == 1'b0) begin
            // Positive number: sign bit zero + magnitude
            c = {1'b0, res_mag};
        end else begin
            // Negative number: two's complement of magnitude with sign bit 1
            // First extend magnitude to N bits with sign 0, then negate

            // Compose positive magnitude with sign 0
            c = (~{1'b0, res_mag} + 1'b1);
        end
    end

endmodule


// Testbench for fixed_point_subtractor
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
        reg signed [N-1:0] sval;
    begin
        sval = val;
        to_real = sval / (2.0 ** Q);
    end
    endfunction

    // Convert real number to fixed-point two's complement
    function [N-1:0] to_fixed(input real val);
    begin
        to_fixed = $rtoi(val * (2.0 ** Q));
    end
    endfunction

    initial begin
        $display("Time | a (real)    | b (real)    | c (real)     | Expected c");
        $display("---------------------------------------------------------------");

        // Test vectors: (a - b)
        a = to_fixed( 1.5);   b = to_fixed( 0.5);  #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 1.5 - 0.5);

        a = to_fixed(-2.25);  b = to_fixed( 1.25); #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), -2.25 - 1.25);

        a = to_fixed( 0.75);  b = to_fixed(-0.75); #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.75 - (-0.75));

        a = to_fixed(-1.0);   b = to_fixed(-1.0);  #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        a = to_fixed( 0.0);   b = to_fixed( 0.0);  #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        a = to_fixed( 127.5); b = to_fixed(-128.0); #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 127.5 - (-128.0));

        a = to_fixed(-64.125); b = to_fixed(64.125); #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), -64.125 - 64.125);

        a = to_fixed(0.0); b = to_fixed(0.125); #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.0 - 0.125);

        $finish;
    end

endmodule