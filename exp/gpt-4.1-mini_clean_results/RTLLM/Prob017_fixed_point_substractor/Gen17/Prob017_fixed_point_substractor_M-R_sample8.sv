`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign
    parameter integer Q = 8    // Fractional bits (for fixed-point context)
)(
    input  wire [N-1:0] a,  // Unsigned input representing signed fixed-point number
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract sign bits (MSB)
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values of inputs
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Compare magnitudes
    wire a_gte_b = (a_abs >= b_abs);

    // Intermediate magnitude result wire
    wire [N-1:0] mag_res;

    // Determine if signs are equal
    wire same_sign = (a_sign == b_sign);

    // Compute magnitude result:
    // If same sign, subtract smaller from larger
    // If different sign, add magnitudes
    wire [N-1:0] mag_sub = a_abs >= b_abs ? (a_abs - b_abs) : (b_abs - a_abs);
    wire [N-1:0] mag_add = a_abs + b_abs;

    // Assign magnitude result according to sign conditions
    assign mag_res = same_sign ? mag_sub : mag_add;

    // Determine result sign:
    // If same sign => result sign = input sign
    // If different sign:
    //    if a >= b magnitude, sign = a_sign else sign = b_sign
    wire res_sign = same_sign ? a_sign :
                    (a_gte_b ? a_sign : b_sign);

    // Form result before zero correction
    wire [N-1:0] res_pre_zero = {res_sign, mag_res[N-2:0]};

    // Explicit zero check (all bits zero)
    wire zero_result = (mag_res == {N{1'b0}});

    // Final result with zero sign forced to zero
    assign c = zero_result ? {1'b0, {(N-1){1'b0}}} : res_pre_zero;

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

    // Convert real number to fixed-point two's complement signed representation
    function [N-1:0] real_to_fixed(input real val);
        real scaled;
        begin
            scaled = val * (2.0 ** Q);
            // Clamp to representable range to avoid overflow
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
        $display("---------------------------------------------------------------------");

        // Test vectors
        a = real_to_fixed(1.5);      b = real_to_fixed(0.5);      #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 1.5 - 0.5);

        a = real_to_fixed(-2.25);    b = real_to_fixed(1.25);     #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -2.25 - 1.25);

        a = real_to_fixed(0.75);     b = real_to_fixed(-0.75);    #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.75 - (-0.75));

        a = real_to_fixed(-1.0);     b = real_to_fixed(-1.0);     #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        a = real_to_fixed(0.0);      b = real_to_fixed(0.0);      #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        a = {1'b0, {(N-1){1'b1}}};  // max positive (close to 1 - 2^-Q)
        b = {1'b1, {(N-1){1'b0}}};  // max negative (-2^(N-1))
        #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), fixed_to_real(a) - fixed_to_real(b));

        a = real_to_fixed(-0.25);    b = real_to_fixed(0.5);      #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -0.25 - 0.5);

        a = real_to_fixed(0.1);      b = real_to_fixed(0.1);      #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        // Edge case: a < b but same sign negative
        a = real_to_fixed(-3.0);     b = real_to_fixed(-4.5);     #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -3.0 - (-4.5));

        // Edge case: a > b but different signs
        a = real_to_fixed(2.0);      b = real_to_fixed(-1.5);     #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 2.0 - (-1.5));

        $finish;
    end
endmodule