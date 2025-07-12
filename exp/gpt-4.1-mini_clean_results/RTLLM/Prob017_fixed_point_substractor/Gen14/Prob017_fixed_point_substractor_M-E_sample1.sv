`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total width (including sign)
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,   // Fixed-point input a in two's complement
    input  wire [N-1:0] b,   // Fixed-point input b in two's complement
    output wire [N-1:0] c    // Fixed-point output c = a - b in two's complement
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute magnitudes (absolute values)
    // For two's complement: if sign=1, magnitude = ~value + 1; else magnitude = value
    wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;

    // Subtraction: c = a - b = a + (-b)
    // So subtracting b means adding two's complement of b.
    // But per problem statement, handle according to sign logic:

    // Case 1: same sign -> subtract magnitudes, result sign = a_sign
    // Case 2: different sign -> add magnitudes, result sign depends on magnitude comparison

    reg [N-1:0] result_mag;
    reg result_sign;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes
            if (a_mag >= b_mag) begin
                result_mag = a_mag - b_mag;
                result_sign = a_sign;
            end else begin
                result_mag = b_mag - a_mag;
                result_sign = ~a_sign; // Opposite sign if b magnitude larger
            end
        end else begin
            // Different signs: add magnitudes
            result_mag = a_mag + b_mag;

            // Determine result sign:
            // If a is positive (a_sign=0), b is negative, result sign positive if a_mag>=b_mag else negative
            // Actually, for addition, sign depends on who has larger magnitude:
            if (a_mag >= b_mag) begin
                result_sign = a_sign; // same as a_sign (which is 0 or 1)
            end else begin
                result_sign = b_sign; // sign of bigger magnitude input
            end
        end

        // Handle zero result: if magnitude is zero, sign = 0
        if (result_mag == 0) begin
            result_sign = 1'b0;
        end
    end

    // Convert back to two's complement representation from sign+magnitude
    // If sign = 0 => positive number = magnitude as is
    // If sign = 1 => negative number = two's complement of magnitude
    wire [N-1:0] result_tc = result_sign ? (~result_mag + 1'b1) : result_mag;

    assign c = result_tc;

endmodule


// Testbench for the fixed_point_subtractor module
module tb_fixed_point_subtractor;

    parameter integer N = 16;
    parameter integer Q = 8;

    reg [N-1:0] a, b;
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
        integer int_val;
    begin
        int_val = $rtoi(val * (2.0 ** Q));
        to_fixed = int_val[N-1:0];
    end
    endfunction

    initial begin
        $display("Time | a (real)    | b (real)    | c (real)     | Expected c");
        $display("--------------------------------------------------------------");

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

        a = to_fixed(-0.5); b = to_fixed(0.5); #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), -0.5 - 0.5);

        a = to_fixed(3.75); b = to_fixed(3.75); #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        $finish;
    end

endmodule