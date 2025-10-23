`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,    // Total bits including sign bit
    parameter integer Q = 8      // Fractional bits
)(
    input  signed [N-1:0] a,    // Input operand a (two's complement fixed-point)
    input  signed [N-1:0] b,    // Input operand b (two's complement fixed-point)
    output signed [N-1:0] c     // Output result c (two's complement fixed-point)
);

    wire signed [N-1:0] diff;
    wire zero_result;

    assign diff = a - b;
    assign zero_result = (diff == {N{1'b0}});

    // If result is zero, force sign bit to 0 by zeroing entire vector
    assign c = zero_result ? {N{1'b0}} : diff;

endmodule


// Testbench to verify fixed_point_subtractor
module tb_fixed_point_subtractor;

    parameter integer N = 16;
    parameter integer Q = 8;

    reg  signed [N-1:0] a, b;
    wire signed [N-1:0] c;

    fixed_point_subtractor #(.N(N), .Q(Q)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    // Convert two's complement fixed-point to real for display
    function real to_real(input signed [N-1:0] val);
    begin
        to_real = val / (2.0 ** Q);
    end
    endfunction

    initial begin
        $display("Time | a (real)  | b (real)  | c (real)   | Expected c");
        $display("-----------------------------------------------------------");

        // 1) a=1.5, b=0.5 => c=1.0
        a = 16'sd384;    // 1.5 * 256
        b = 16'sd128;    // 0.5 * 256
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 1.5 - 0.5);

        // 2) a=-2.25, b=1.25 => c=-3.5
        a = -16'sd576;   // -2.25 * 256
        b = 16'sd320;    // 1.25 * 256
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), -2.25 - 1.25);

        // 3) a=0.75, b=-0.75 => c=1.5
        a = 16'sd192;    // 0.75 * 256
        b = -16'sd192;   // -0.75 * 256
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.75 - (-0.75));

        // 4) a=-1.0, b=-1.0 => c=0.0 (zero sign bit forced 0)
        a = -16'sd256;   // -1.0 * 256
        b = -16'sd256;   // -1.0 * 256
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // 5) a=0.0, b=0.0 => c=0.0
        a = 16'sd0;
        b = 16'sd0;
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // 6) Max positive - max negative
        a = 16'sd32767;   // max positive 16-bit signed (approx 127.996)
        b = -16'sd32768;  // max negative 16-bit signed (-128.0)
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c),
                 (32767/(2.0**Q))-(-32768/(2.0**Q)));

        // 7) a=0.5, b=-1.0 => c=1.5
        a = 16'sd128;
        b = -16'sd256;
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.5 - (-1.0));

        // 8) a=-2.0, b=-2.5 => c=0.5
        a = -16'sd512;
        b = -16'sd640;
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), -2.0 - (-2.5));

        $finish;
    end

endmodule