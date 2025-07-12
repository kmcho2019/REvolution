`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,      // Total bits including sign bit
    parameter integer Q = 8        // Fractional bits (for reference)
)(
    input  wire [N-1:0] a,         // Input operand a (two's complement fixed-point)
    input  wire [N-1:0] b,         // Input operand b (two's complement fixed-point)
    output wire [N-1:0] c          // Output result c (two's complement fixed-point)
);

    // Perform subtraction directly in two's complement
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    wire signed [N-1:0] res_signed = a_signed - b_signed;

    // If result is zero, force sign bit to zero by assigning zero vector
    wire zero_result = (res_signed == 0);

    // Final result: if zero, all zeros; else the subtraction result
    // This ensures sign bit of zero is zero, per spec
    assign c = zero_result ? {N{1'b0}} : res_signed;

endmodule


// Testbench for fixed_point_subtractor to verify correctness
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

    // Convert two's complement fixed-point to real for display
    function real to_real(input [N-1:0] val);
        reg signed [N-1:0] sval;
    begin
        sval = val;
        to_real = sval / (2.0 ** Q);
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
        a = 16'sd32767;   // max positive 16-bit signed
        b = -16'sd32768;  // max negative 16-bit signed
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 
                 (32767/(2.0**Q))-(-32768/(2.0**Q)));

        // 7) a < b with different sign (a positive, b negative, a < b)
        a = 16'sd128;    // 0.5
        b = -16'sd256;   // -1.0
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.5 - (-1.0));

        // 8) a < b same sign negative (expect negative result)
        a = -16'sd512;   // -2.0
        b = -16'sd640;   // -2.5
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), -2.0 - (-2.5));

        $finish;
    end

endmodule