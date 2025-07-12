`timescale 1ns/1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign)
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,  // Fixed-point input a (signed two's complement)
    input  wire [N-1:0] b,  // Fixed-point input b (signed two's complement)
    output reg  [N-1:0] c   // Fixed-point output c = a - b (signed two's complement)
);

    // Internal signals
    reg sign_a, sign_b, sign_c;
    reg [N-2:0] mag_a, mag_b, mag_res; // Magnitude (absolute value) without sign bit
    reg [N-1:0] tmp_res_unsigned;
    reg [N-2:0] abs_diff;
    reg [N-1:0] sum_mag;

    // Convert 2's complement input to sign-magnitude form
    always @(*) begin
        // Extract sign bits
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Convert to magnitude (absolute value)
        if (sign_a)
            mag_a = (~a[N-2:0] + 1'b1);
        else
            mag_a = a[N-2:0];

        if (sign_b)
            mag_b = (~b[N-2:0] + 1'b1);
        else
            mag_b = b[N-2:0];

        // Initialize result signals
        mag_res = 0;
        sign_c = 0;
        tmp_res_unsigned = 0;

        if (sign_a == sign_b) begin
            // Same sign subtraction of magnitudes: mag_a - mag_b
            if (mag_a >= mag_b) begin
                abs_diff = mag_a - mag_b;
                sign_c = sign_a; // same sign
            end else begin
                abs_diff = mag_b - mag_a;
                // Result sign is same as operands (per problem statement, sign of result same as inputs)
                // But when mag_b > mag_a and same sign, result sign flips:
                // The problem says "sign of the result will be the same as inputs" in same sign case.
                // But if mag_b > mag_a, actual subtraction result would be negative.
                // To maintain correctness, use sign of larger magnitude:
                // The problem states sign same as inputs, which is ambiguous for magnitude difference.
                // To correctly reflect subtraction semantics:
                // If same sign and mag_b > mag_a, result sign flips.
                // So interpret as sign of result = sign_a if mag_a >= mag_b, else inverse sign_a.
                sign_c = (sign_a == 1'b0) ? 1'b1 : 1'b0;
            end
            mag_res = abs_diff;
        end else begin
            // Different sign: result = mag_a + mag_b, sign depends on which abs val is larger and sign of operands
            sum_mag = {1'b0, mag_a} + {1'b0, mag_b};
            tmp_res_unsigned = sum_mag;
            if (mag_a > mag_b)
                sign_c = sign_a; // sign of operand with larger magnitude
            else if (mag_b > mag_a)
                sign_c = sign_b;
            else
                sign_c = 1'b0; // magnitudes equal, result zero, sign 0
            mag_res = sum_mag[N-2:0];
        end

        // Handle zero result explicitly (both magnitude bits zero)
        if (mag_res == 0)
            sign_c = 1'b0;

        // Convert sign-magnitude back to two's complement signed number
        if (sign_c) begin
            // Negative result: two's complement from magnitude
            c = {1'b1, (~mag_res + 1'b1)};
        end else begin
            // Positive result: sign bit 0, magnitude unchanged
            c = {1'b0, mag_res};
        end
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

    // Convert fixed-point two's complement to real for display
    function real to_real(input [N-1:0] val);
        integer signed_val;
    begin
        signed_val = $signed(val);
        to_real = signed_val / (2.0 ** Q);
    end
    endfunction

    initial begin
        $display("Time | a (real)   | b (real)   | c (real)    | Expected c");
        $display("-------------------------------------------------------------");

        a = 16'sd384;   b = 16'sd128;   #5;  // 1.5 - 0.5 = 1.0
        $display("%4t | %10f | %10f | %11f | %10f", $time, to_real(a), to_real(b), to_real(c), 1.5-0.5);

        a = -16'sd576;  b = 16'sd320;   #5;  // -2.25 - 1.25 = -3.5
        $display("%4t | %10f | %10f | %11f | %10f", $time, to_real(a), to_real(b), to_real(c), -2.25-1.25);

        a = 16'sd192;   b = -16'sd192;  #5;  // 0.75 - (-0.75) = 1.5
        $display("%4t | %10f | %10f | %11f | %10f", $time, to_real(a), to_real(b), to_real(c), 0.75-(-0.75));

        a = -16'sd256;  b = -16'sd256;  #5;  // -1.0 - (-1.0) = 0.0
        $display("%4t | %10f | %10f | %11f | %10f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        a = 16'sd0;     b = 16'sd0;     #5;  // 0.0 - 0.0 = 0.0
        $display("%4t | %10f | %10f | %11f | %10f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        a = 16'sd32767; b = -16'sd32768; #5; // Max positive - max negative
        $display("%4t | %10f | %10f | %11f | %10f", $time, to_real(a), to_real(b), to_real(c), (32767/(2.0**Q))-(-32768/(2.0**Q)));

        a = -16'sd1;    b = 16'sd2;     #5;  // -0.00390625 - 0.0078125 = -0.01171875
        $display("%4t | %10f | %10f | %11f | %10f", $time, to_real(a), to_real(b), to_real(c), -1/(2.0**Q) - 2/(2.0**Q));

        $finish;
    end

endmodule