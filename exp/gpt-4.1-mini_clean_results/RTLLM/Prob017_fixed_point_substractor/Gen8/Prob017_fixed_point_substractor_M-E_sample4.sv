`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,      // Total bits (including sign)
    parameter integer Q = 8        // Fractional bits (for reference)
)(
    input  wire [N-1:0] a,         // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,         // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c          // Fixed-point output result c (two's complement)
);

    reg signed [N-1:0] signed_a, signed_b;
    reg signed [N-1:0] res;

    always @(*) begin
        // Cast inputs as signed values for arithmetic
        signed_a = a;
        signed_b = b;

        // Perform subtraction directly
        res = signed_a - signed_b;

        // If result is zero, force sign bit to zero
        if (res == 0)
            c = {1'b0, {(N-1){1'b0}}};
        else
            c = res;
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

        // Test vectors: (a, b) and expected results

        // 1) 1.5 - 0.5 = 1.0
        a = 16'sd384;    // 1.5 * 256
        b = 16'sd128;    // 0.5 * 256
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 1.5 - 0.5);

        // 2) -2.25 - 1.25 = -3.5
        a = -16'sd576;   // -2.25 * 256
        b = 16'sd320;    // 1.25 * 256
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), -2.25 - 1.25);

        // 3) 0.75 - (-0.75) = 1.5
        a = 16'sd192;    // 0.75 * 256
        b = -16'sd192;   // -0.75 * 256
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.75 - (-0.75));

        // 4) -1.0 - (-1.0) = 0.0 (sign bit forced zero)
        a = -16'sd256;   // -1.0 * 256
        b = -16'sd256;   // -1.0 * 256
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // 5) 0.0 - 0.0 = 0.0
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

        // 7) 0.5 - (-1.0) = 1.5
        a = 16'sd128;    // 0.5
        b = -16'sd256;   // -1.0
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.5 - (-1.0));

        // 8) -2.0 - (-2.5) = 0.5
        a = -16'sd512;   // -2.0
        b = -16'sd640;   // -2.5
        #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), -2.0 - (-2.5));

        $finish;
    end

endmodule