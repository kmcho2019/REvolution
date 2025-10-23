`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,   // Total bits (including sign)
    parameter integer Q = 8     // Fractional bits (for information)
)(
    input  wire [N-1:0] a,     // N-bit fixed-point inputs (two's complement)
    input  wire [N-1:0] b,
    output reg  [N-1:0] c      // N-bit fixed-point output (two's complement)
);

    // Internal signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0]; // abs(a) magnitude
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0]; // abs(b) magnitude

    reg [N-1:0] res_twos;       // Two's complement result register for intermediate result
    reg res_sign;
    reg [N-2:0] res_mag;
    reg mag_greater;

    // Compare magnitudes (for sign decisions)
    wire a_gt_b = (a_mag > b_mag);
    wire a_eq_b = (a_mag == b_mag);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: res_mag = |a| - |b|
            if (a_gt_b) begin
                res_mag  = a_mag - b_mag;
                res_sign = a_sign;
            end else if (a_eq_b) begin
                res_mag  = { (N-1){1'b0} };
                res_sign = 1'b0;  // zero sign forced to 0
            end else begin
                res_mag  = b_mag - a_mag;
                res_sign = a_sign; // same sign as inputs even if b_mag > a_mag (bigger magnitude)
            end
            // Because same sign subtraction, result sign = sign of inputs regardless of mag comparison.
            // To match expected behavior: if b_mag > a_mag, subtraction would give negative number if inputs negative.
            // Actually this logic needs refinement: for same sign subtraction, the sign of result equals input sign, but magnitude difference sign depends on which is bigger.
            // So refine sign when same sign:
            if (a_gt_b) begin
                // res_sign = a_sign;
            end else if (a_eq_b) begin
                res_sign = 1'b0;
            end else begin
                // When b_mag > a_mag and inputs same sign, result sign = input sign but inverted, because magnitude subtraction swapped
                // For example a=-3,b=-5: res = -3 - (-5) = 2 (positive), sign bit 0
                // So invert sign if b_mag > a_mag for same sign inputs
                res_sign = ~a_sign;
            end
        end else begin
            // Different signs: res_mag = |a| + |b|
            res_mag = a_mag + b_mag;
            // Sign of result = sign of operand with larger magnitude
            if (a_gt_b) begin
                res_sign = a_sign;
            end else if (a_eq_b) begin
                res_sign = 1'b0; // zero sign forced zero
                res_mag = { (N-1){1'b0} };
            end else begin
                res_sign = b_sign;
            end
        end

        // Compose two's complement result from sign and magnitude
        if (res_mag == { (N-1){1'b0} }) begin
            // Zero result: force sign bit zero
            res_twos = {1'b0, {(N-1){1'b0}}};
        end else begin
            if (res_sign == 1'b0) begin
                // positive result
                res_twos = {1'b0, res_mag};
            end else begin
                // negative result: two's complement of magnitude
                res_twos = {1'b1, (~res_mag + 1'b1)};
            end
        end

        c = res_twos;
    end

endmodule


// Testbench to verify correct behavior for various cases
module tb_fixed_point_subtractor;
    parameter integer N = 16;
    parameter integer Q = 8;

    reg [N-1:0] a;
    reg [N-1:0] b;
    wire [N-1:0] c;

    fixed_point_subtractor #(.N(N), .Q(Q)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    // Convert real to fixed-point two's complement
    function [N-1:0] real_to_fixed(input real val);
        real scaled;
        begin
            scaled = val * (2.0 ** Q);
            if (scaled >= 2.0**(N-1) - 1)
                real_to_fixed = {1'b0, {(N-1){1'b1}}}; // max positive
            else if (scaled < -(2.0**(N-1)))
                real_to_fixed = {1'b1, {(N-1){1'b0}}}; // max negative
            else
                real_to_fixed = $rtoi(scaled);
        end
    endfunction

    // Convert fixed-point two's complement to real
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

        // Tests: a - b = c expected
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

        // Edge cases
        a = real_to_fixed(-3.0);     b = real_to_fixed(-4.5);     #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -3.0 - (-4.5));

        a = real_to_fixed(2.0);      b = real_to_fixed(-1.5);     #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 2.0 - (-1.5));

        $finish;
    end
endmodule