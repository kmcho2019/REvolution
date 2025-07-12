`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign)
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a, // Fixed-point input a, two's complement signed
    input  wire [N-1:0] b, // Fixed-point input b, two's complement signed
    output reg  [N-1:0] c  // Fixed-point output c = a - b
);

    // Internal signals
    reg sign_a, sign_b;
    reg [N-2:0] mag_a, mag_b;    // Magnitude bits (N-1 bits without sign)
    reg [N-1:0] mag_res;          // Result magnitude including overflow bit if needed
    reg sign_res;

    reg [N-1:0] res_sub, res_add;

    // Compute absolute values
    function [N-2:0] abs_mag(input [N-1:0] val);
        begin
            if (val[N-1] == 1'b1) // negative number
                abs_mag = (~val[N-2:0] + 1'b1);
            else
                abs_mag = val[N-2:0];
        end
    endfunction

    // Compare magnitudes
    function mag_greater_equal(input [N-1:0] x, input [N-1:0] y);
        begin
            mag_greater_equal = (x >= y);
        end
    endfunction

    // Main combinational block to compute subtraction based on sign
    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];
        mag_a = abs_mag(a);
        mag_b = abs_mag(b);

        if (sign_a == sign_b) begin
            // Same sign subtraction: magnitude subtraction mag_a - mag_b
            if (mag_a >= mag_b) begin
                mag_res = {1'b0, mag_a} - {1'b0, mag_b}; // no overflow, 1 bit wider
                sign_res = sign_a;
            end else begin
                mag_res = {1'b0, mag_b} - {1'b0, mag_a};
                sign_res = ~sign_a; // opposite sign if mag_b > mag_a
            end
        end else begin
            // Different signs: addition mag_a + mag_b
            mag_res = {1'b0, mag_a} + {1'b0, mag_b};
            // Sign depends on which magnitude is greater
            if (mag_a >= mag_b) begin
                sign_res = sign_a;
            end else begin
                sign_res = sign_b;
            end
        end

        // Handle zero result: if magnitude is zero, force sign = 0
        if (mag_res == 0) begin
            sign_res = 1'b0;
        end

        // Assign final output c: combine sign and magnitude
        // c = sign_res concatenated with magnitude bits (discarding extra msb of mag_res)
        c = {sign_res, mag_res[N-2:0]};
    end

endmodule


// Testbench to validate the fixed_point_subtractor module
module tb_fixed_point_subtractor();

    parameter integer N = 16;
    parameter integer Q = 8;

    reg  [N-1:0] a, b;
    wire [N-1:0] c;

    fixed_point_subtractor #(.N(N), .Q(Q)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    // Convert fixed-point to real number for readability
    function real to_real(input [N-1:0] val);
        reg signed [N-1:0] sval;
        begin
            sval = val;
            to_real = sval / (2.0**Q);
        end
    endfunction

    initial begin
        $display("Time | a (real)   | b (real)   | c (real)    | Expected c");
        $display("-------------------------------------------------------------");

        // 1.5 - 0.5 = 1.0
        a = 16'sd384;    // 1.5 in Q8 fixed point (384 / 256)
        b = 16'sd128;    // 0.5
        #5;
        $display("%4t | %10f | %10f | %11f | %10f", $time, to_real(a), to_real(b), to_real(c), 1.5 - 0.5);

        // -2.25 - 1.25 = -3.5
        a = -16'sd576;   // -2.25
        b = 16'sd320;    // 1.25
        #5;
        $display("%4t | %10f | %10f | %11f | %10f", $time, to_real(a), to_real(b), to_real(c), -2.25 - 1.25);

        // 0.75 - (-0.75) = 1.5
        a = 16'sd192;    // 0.75
        b = -16'sd192;   // -0.75
        #5;
        $display("%4t | %10f | %10f | %11f | %10f", $time, to_real(a), to_real(b), to_real(c), 0.75 - (-0.75));

        // -1.0 - (-1.0) = 0.0 (zero result test)
        a = -16'sd256;   // -1.0
        b = -16'sd256;   // -1.0
        #5;
        $display("%4t | %10f | %10f | %11f | %10f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // 0.0 - 0.0 = 0.0 (zero inputs)
        a = 16'sd0;
        b = 16'sd0;
        #5;
        $display("%4t | %10f | %10f | %11f | %10f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // Max positive - max negative
        a = 16'sd32767;    // max positive signed 16-bit value
        b = -16'sd32768;   // max negative signed 16-bit value
        #5;
        $display("%4t | %10f | %10f | %11f | %10f", $time, to_real(a), to_real(b), to_real(c), (32767/(2.0**Q)) - (-32768/(2.0**Q)));

        // Edge case: a < b, both positive
        a = 16'sd128;  // 0.5
        b = 16'sd384;  // 1.5
        #5;
        $display("%4t | %10f | %10f | %11f | %10f", $time, to_real(a), to_real(b), to_real(c), 0.5 - 1.5);

        // Edge case: a negative, b positive, a magnitude > b magnitude
        a = -16'sd512; // -2.0
        b = 16'sd256;  // 1.0
        #5;
        $display("%4t | %10f | %10f | %11f | %10f", $time, to_real(a), to_real(b), to_real(c), -2.0 - 1.0);

        $finish;
    end

endmodule