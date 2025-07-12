`timescale 1ns/1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits
    parameter integer Q = 8    // Fractional bits
)(
    input  wire signed [N-1:0] a,  // Signed fixed-point input a
    input  wire signed [N-1:0] b,  // Signed fixed-point input b
    output wire signed [N-1:0] c   // Signed fixed-point output c = a - b
);

    // Perform subtraction as signed operation
    wire signed [N-1:0] res = a - b;

    // Mask to clear sign bit if result is zero, else pass res unchanged
    wire [N-1:0] zero_mask = (res == 0) ? {{1'b0}, {(N-1){1'b1}}} : {N{1'b1}};

    assign c = res & zero_mask;

endmodule


// Simple testbench to verify functionality
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

    // Convert fixed-point to real for display
    function real to_real(input signed [N-1:0] val);
    begin
        to_real = val / (2.0 ** Q);
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

        $finish;
    end

endmodule