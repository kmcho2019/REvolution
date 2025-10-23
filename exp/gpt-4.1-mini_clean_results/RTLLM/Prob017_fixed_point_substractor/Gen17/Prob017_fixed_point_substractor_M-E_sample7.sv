`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,    // Fixed-point input operand (two's complement)
    input  wire [N-1:0] b,
    output reg  [N-1:0] c     // Fixed-point output operand
);

    // Internal signals for sign extraction
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitude extraction (absolute value without sign)
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Internal registers for calculation
    reg [N-2:0] res_mag;
    reg res_sign;

    // Compare magnitudes for sign determination when signs differ
    wire a_gt_b_mag = (a_mag > b_mag);

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: res = a_mag - b_mag
            if (a_mag >= b_mag) begin
                res_mag = a_mag - b_mag;
                res_sign = a_sign;  // Same sign as inputs
            end else begin
                res_mag = b_mag - a_mag;
                res_sign = ~a_sign; // Opposite sign (borrow)
            end
        end else begin
            // Different sign subtraction is effectively adding magnitudes
            res_mag = a_mag + b_mag;
            // Sign depends on which magnitude is greater: result sign = sign of larger magnitude operand
            if (a_gt_b_mag)
                res_sign = a_sign;
            else
                res_sign = b_sign;
        end

        // If result magnitude is zero, force sign bit to zero
        if (res_mag == { (N-1){1'b0} }) begin
            res_sign = 1'b0;
        end

        // Compose final result in two's complement signed fixed-point format
        // If sign == 0, c = +res_mag
        // If sign == 1, c = two's complement negation of res_mag
        if (res_sign == 1'b0) begin
            c = {1'b0, res_mag};
        end else begin
            // Take two's complement of res_mag to form negative value
            c = {1'b1, (~res_mag + 1'b1)};
        end
    end

endmodule


// Testbench for fixed_point_subtractor module
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