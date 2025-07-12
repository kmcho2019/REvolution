`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,     // Fixed-point input operands (two's complement)
    input  wire [N-1:0] b,
    output wire [N-1:0] c      // Fixed-point output (two's complement)
);

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Extract absolute values (magnitude) of a and b
    // Using two's complement magnitude extraction: if negative, negate
    wire [N-1:0] abs_a = sign_a ? (~a + 1) : a;
    wire [N-1:0] abs_b = sign_b ? (~b + 1) : b;

    // Internal signals for magnitude result and sign of result
    wire [N-1:0] mag_res_sub; // magnitude when subtracting abs values
    wire [N-1:0] mag_res_add; // magnitude when adding abs values

    wire sub_a_gt_b;          // true if abs_a > abs_b
    wire zero_mag_res;        // true if magnitude result is zero

    // Compare magnitudes (unsigned)
    assign sub_a_gt_b = (abs_a > abs_b);

    // Subtraction of magnitudes: always abs_a - abs_b, with abs_a >= abs_b if used
    assign mag_res_sub = sub_a_gt_b ? (abs_a - abs_b) : (abs_b - abs_a);

    // Addition of magnitudes: abs_a + abs_b (for different sign case)
    assign mag_res_add = abs_a + abs_b;

    // Determine result magnitude and sign according to sign combinations:
    // Same sign: magnitude = abs_a - abs_b (or abs_b - abs_a), sign = sign_a (if abs_a >= abs_b), else inverse sign
    // Different sign: magnitude = abs_a + abs_b, sign depends on which absolute value is greater

    // Result magnitude and sign signals
    reg [N-1:0] mag_res;
    reg         sign_res;

    // Combinational logic for assigning mag_res and sign_res
    // Use a combinational always block for clarity
    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign: subtract magnitudes
            if (sub_a_gt_b) begin
                mag_res = mag_res_sub;
                sign_res = sign_a; // sign same as inputs
            end else if (abs_a == abs_b) begin
                mag_res = 0;
                sign_res = 1'b0; // zero sign forced to 0
            end else begin
                mag_res = mag_res_sub;
                sign_res = ~sign_a; // opposite sign if b magnitude greater
            end
        end else begin
            // Different signs: add magnitudes
            mag_res = mag_res_add;
            // sign_res determined by which abs is greater
            if (abs_a == abs_b) begin
                mag_res = 0;
                sign_res = 1'b0; // zero sign forced 0
            end else if (sub_a_gt_b) begin
                sign_res = sign_a;
            end else begin
                sign_res = sign_b;
            end
        end
    end

    // Compose result: if magnitude zero, enforce zero sign bit
    wire zero_mag = (mag_res == 0);

    // Compose final two's complement output
    // If sign_res=0 (positive), output mag_res
    // If sign_res=1 (negative), output two's complement of mag_res (negate)

    wire [N-1:0] res_pos = mag_res;
    wire [N-1:0] res_neg = (~mag_res) + 1;

    assign c = zero_mag ? {1'b0, {(N-1){1'b0}}} :
               (sign_res ? res_neg : res_pos);

endmodule


// Testbench to verify behavior
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

    // Convert real to fixed-point two's complement
    function [N-1:0] real_to_fixed(input real val);
        real scaled;
        begin
            scaled = val * (2.0 ** Q);
            // Clamp to representable range
            if (scaled > (2.0**(N-1)-1))
                real_to_fixed = (2**(N-1)) - 1;
            else if (scaled < -(2.0**(N-1)))
                real_to_fixed = -(2**(N-1));
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

        a = {1'b0, {(N-1){1'b1}}};  // max positive
        b = {1'b1, {(N-1){1'b0}}};  // max negative
        #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), fixed_to_real(a) - fixed_to_real(b));

        a = real_to_fixed(-0.25);    b = real_to_fixed(0.5);      #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -0.25 - 0.5);

        a = real_to_fixed(0.1);      b = real_to_fixed(0.1);      #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        a = real_to_fixed(-3.0);     b = real_to_fixed(-4.5);     #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -3.0 - (-4.5));

        a = real_to_fixed(2.0);      b = real_to_fixed(-1.5);     #5;
        $display("%4t | %15f | %15f | %15f | %15f",
            $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 2.0 - (-1.5));

        $finish;
    end
endmodule