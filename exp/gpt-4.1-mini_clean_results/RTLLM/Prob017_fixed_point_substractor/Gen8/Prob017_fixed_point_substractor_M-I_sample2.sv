`timescale 1ns/1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign)
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,  // Fixed-point input a (signed two's complement)
    input  wire [N-1:0] b,  // Fixed-point input b (signed two's complement)
    output wire [N-1:0] c   // Fixed-point output c = a - b (signed two's complement)
);

    wire signed [N-1:0] signed_a = $signed(a);
    wire signed [N-1:0] signed_b = $signed(b);
    wire signed [N-1:0] diff = signed_a - signed_b;

    // If result is zero, explicitly force sign bit to 0
    assign c = (diff == 0) ? {1'b0, {(N-1){1'b0}}} : diff;

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