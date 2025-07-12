`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,    // total bits
    parameter integer Q = 8      // fractional bits
)(
    input  wire [N-1:0] a,       // fixed-point input a in two's complement
    input  wire [N-1:0] b,       // fixed-point input b in two's complement
    output reg  [N-1:0] c        // fixed-point output c = a - b in two's complement
);

    // Internal register for result
    reg [N-1:0] res;

    always @* begin
        res = a - b;
        // If result is zero, explicitly clear sign bit to 0
        if (res == 0)
            res[N-1] = 1'b0;
    end

    always @* begin
        c = res;
    end

endmodule


// Testbench to validate functionality
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

    // Convert fixed-point two's complement to real number
    function real to_real(input [N-1:0] val);
        reg signed [N-1:0] sval;
    begin
        sval = val;
        to_real = $itor(sval) / (2.0 ** Q);
    end
    endfunction

    initial begin
        $display("Time | a (real)   | b (real)   | c (real)    | Expected c");

        // 1.5 - 0.5 = 1.0
        a = 16'sd384; // 1.5 * 256 = 384
        b = 16'sd128; // 0.5 * 256 = 128
        #5;
        $display("%4t | %11f | %11f | %11f | %11f", $time, to_real(a), to_real(b), to_real(c), 1.5 - 0.5);

        // -2.25 - 1.25 = -3.5
        a = -16'sd576; // -2.25 * 256 = -576
        b = 16'sd320;  // 1.25 * 256 = 320
        #5;
        $display("%4t | %11f | %11f | %11f | %11f", $time, to_real(a), to_real(b), to_real(c), -2.25 - 1.25);

        // 0.75 - (-0.75) = 1.5
        a = 16'sd192;   // 0.75 * 256 = 192
        b = -16'sd192;  // -0.75 * 256 = -192
        #5;
        $display("%4t | %11f | %11f | %11f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.75 - (-0.75));

        // -1.0 - (-1.0) = 0.0
        a = -16'sd256;  // -1.0 * 256 = -256
        b = -16'sd256;  // -1.0 * 256 = -256
        #5;
        $display("%4t | %11f | %11f | %11f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // 0.0 - 0.0 = 0.0
        a = 16'sd0;
        b = 16'sd0;
        #5;
        $display("%4t | %11f | %11f | %11f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // Max positive - max negative
        a = 16'sd32767;  // max positive for 16-bit signed
        b = -16'sd32768; // max negative for 16-bit signed
        #5;
        $display("%4t | %11f | %11f | %11f | %11f", $time, to_real(a), to_real(b), to_real(c), 
                 (32767 / (2.0**Q)) - (-32768 / (2.0**Q)));

        // -1.5 - 2.5 = -4.0
        a = -16'sd384;  // -1.5 * 256 = -384
        b = 16'sd640;   // 2.5 * 256 = 640
        #5;
        $display("%4t | %11f | %11f | %11f | %11f", $time, to_real(a), to_real(b), to_real(c), -1.5 - 2.5);

        // 3.25 - (-1.75) = 5.0
        a = 16'sd832;   // 3.25 * 256 = 832
        b = -16'sd448;  // -1.75 * 256 = -448
        #5;
        $display("%4t | %11f | %11f | %11f | %11f", $time, to_real(a), to_real(b), to_real(c), 3.25 - (-1.75));

        $finish;
    end

endmodule