`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,     // Fixed-point inputs (two's complement)
    input  wire [N-1:0] b,
    output wire [N-1:0] c      // Fixed-point output (two's complement)
);

    // Extract signs
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Extract magnitudes (absolute values) as unsigned [N-1:0]
    wire [N-1:0] a_abs = a_sign ? (~a + 1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1) : b;

    // Same sign: perform magnitude subtraction (a_abs - b_abs)
    wire [N-1:0] mag_sub;
    wire         sub_a_ge_b = (a_abs >= b_abs);
    assign mag_sub = sub_a_ge_b ? (a_abs - b_abs) : (b_abs - a_abs);

    // Different sign: perform magnitude addition (a_abs + b_abs)
    wire [N-1:0] mag_add = a_abs + b_abs;

    // Determine result magnitude and sign
    wire same_sign = (a_sign == b_sign);

    wire [N-1:0] result_mag = same_sign ? mag_sub : mag_add;

    // Result sign logic:
    // If same sign:
    //   sign = a_sign if a_abs >= b_abs else inverted a_sign
    // If different sign:
    //   sign = sign of the operand with larger magnitude

    wire result_sign_same = sub_a_ge_b ? a_sign : ~a_sign;
    wire result_sign_diff = (a_abs >= b_abs) ? a_sign : b_sign;

    wire result_sign = same_sign ? result_sign_same : result_sign_diff;

    // Handle zero result: if magnitude is zero, sign is 0
    wire is_zero = (result_mag == 0);

    wire final_sign = is_zero ? 1'b0 : result_sign;

    // Convert magnitude and sign back to two's complement
    // If positive, just magnitude
    // If negative, two's complement negate magnitude

    wire [N-1:0] neg_result_mag = (~result_mag) + 1;

    assign c = is_zero ? {N{1'b0}} : (final_sign ? neg_result_mag : result_mag);

endmodule


// Testbench to verify the implementation

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

    // Convert real number to fixed-point two's complement signed representation
    function [N-1:0] real_to_fixed(input real val);
        real scaled;
        begin
            scaled = val * (2.0 ** Q);
            if (scaled > (2.0**(N-1)-1))
                real_to_fixed = (2**(N-1)) - 1;
            else if (scaled < -(2.0**(N-1)))
                real_to_fixed = -(2**(N-1));
            else
                real_to_fixed = $rtoi(scaled);
        end
    endfunction

    // Convert fixed-point two's complement to real number
    function real fixed_to_real(input [N-1:0] val);
        reg signed [N-1:0] sval;
        begin
            sval = val;
            fixed_to_real = sval / (2.0 ** Q);
        end
    endfunction

    initial begin
        $display("Time |        a        |        b        |        c        | Expected");
        $display("---------------------------------------------------------------");

        a = real_to_fixed(1.5); b = real_to_fixed(0.5); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 1.5 - 0.5);

        a = real_to_fixed(-2.25); b = real_to_fixed(1.25); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -2.25 - 1.25);

        a = real_to_fixed(0.75); b = real_to_fixed(-0.75); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.75 - (-0.75));

        a = real_to_fixed(-1.0); b = real_to_fixed(-1.0); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        a = real_to_fixed(0.0); b = real_to_fixed(0.0); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        a = {1'b0, {(N-1){1'b1}}}; // max positive
        b = {1'b1, {(N-1){1'b0}}}; // max negative (two's complement min)
        #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), fixed_to_real(a) - fixed_to_real(b));

        // Additional test: smaller magnitude with opposite signs
        a = real_to_fixed(-0.25); b = real_to_fixed(0.5); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -0.25 - 0.5);

        a = real_to_fixed(0.1); b = real_to_fixed(0.1); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_fixed(b), fixed_to_real(c), 0.0);

        $finish;
    end
endmodule