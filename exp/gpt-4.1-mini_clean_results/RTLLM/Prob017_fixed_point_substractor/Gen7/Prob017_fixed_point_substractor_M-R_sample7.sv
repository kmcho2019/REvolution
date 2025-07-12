`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign bit)
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,     // N-bit fixed-point input a (two's complement)
    input  wire [N-1:0] b,     // N-bit fixed-point input b (two's complement)
    output wire [N-1:0] c      // N-bit fixed-point output c (two's complement)
);

    // Internal signed registers for calculation
    reg signed [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Calculate absolute values for a and b
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Magnitude comparison: 1 if |a| >= |b|
    wire a_ge_b = (a_abs >= b_abs);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes
            if (a_ge_b) begin
                // Result sign same as inputs
                res = a_sign ? -$signed(b_abs - a_abs) : $signed(a_abs - b_abs);
            end else begin
                res = a_sign ? -$signed(a_abs - b_abs) : $signed(b_abs - a_abs);
                // Sign same as inputs, so reverse sign if b_abs > a_abs
                res = ~res + 1'b1; // flip sign because b > a but same sign
            end
        end else begin
            // Different sign: add magnitudes
            if (a_ge_b) begin
                // Result sign same as a
                if (a_sign)
                    res = -$signed(a_abs + b_abs);
                else
                    res = $signed(a_abs + b_abs);
            end else begin
                // Result sign same as b
                if (b_sign)
                    res = -$signed(a_abs + b_abs);
                else
                    res = $signed(a_abs + b_abs);
            end
        end

        // When result is zero, force sign bit to 0
        if (res == 0)
            res = {1'b0, {(N-1){1'b0}}};
    end

    assign c = res;

endmodule


// Testbench for the refactored fixed_point_subtractor
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

    function real to_real(input signed [N-1:0] val);
    begin
        to_real = val / (2.0 ** Q);
    end
    endfunction

    initial begin
        $display("Time | a (real)  | b (real)  | c (real)   | Expected c");
        $display("-----------------------------------------------------------");

        // 1) a=1.5, b=0.5 => c=1.0
        a = 16'sd384;    // 1.5*256 = 384
        b = 16'sd128;    // 0.5*256 = 128
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real($signed(c)), 1.5 - 0.5);

        // 2) a=-2.25, b=1.25 => c=-3.5
        a = -16'sd576;   // -2.25*256 = -576
        b = 16'sd320;    // 1.25*256 = 320
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real($signed(a)), to_real($signed(b)), to_real($signed(c)), -2.25 - 1.25);

        // 3) a=0.75, b=-0.75 => c=1.5
        a = 16'sd192;    // 0.75*256 = 192
        b = -16'sd192;   // -0.75*256 = -192
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real($signed(a)), to_real($signed(b)), to_real($signed(c)), 0.75 - (-0.75));

        // 4) a=-1.0, b=-1.0 => c=0.0
        a = -16'sd256;   // -1.0*256 = -256
        b = -16'sd256;   // -1.0*256 = -256
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real($signed(a)), to_real($signed(b)), to_real($signed(c)), 0.0);

        // 5) a=0.0, b=0.0 => c=0.0
        a = 16'sd0;
        b = 16'sd0;
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real($signed(a)), to_real($signed(b)), to_real($signed(c)), 0.0);

        // 6) Max positive - max negative
        a = 16'sd32767;   // max positive 16-bit signed
        b = -16'sd32768;  // max negative 16-bit signed
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real($signed(a)), to_real($signed(b)), to_real($signed(c)), (32767/(2.0**Q))-(-32768/(2.0**Q)));

        // 7) a = 0.5, b = -1.0 => c = 1.5
        a = 16'sd128;
        b = -16'sd256;
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real($signed(a)), to_real($signed(b)), to_real($signed(c)), 0.5 - (-1.0));

        // 8) a = -2.0, b = -2.5 => c = 0.5
        a = -16'sd512;
        b = -16'sd640;
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real($signed(a)), to_real($signed(b)), to_real($signed(c)), -2.0 - (-2.5));

        $finish;
    end

endmodule