`timescale 1ns/1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,    // Input operand a (fixed-point, 2's complement)
    input  wire [N-1:0] b,    // Input operand b (fixed-point, 2's complement)
    output wire [N-1:0] c     // Output fixed-point subtraction result
);

    // Declare signed versions of inputs and output internal reg
    wire signed [N-1:0] signed_a = $signed(a);
    wire signed [N-1:0] signed_b = $signed(b);

    reg signed [N-1:0] signed_c;

    always @(*) begin
        signed_c = signed_a - signed_b;

        // When result is zero, explicitly set sign bit to 0
        if (signed_c == 0)
            signed_c = {1'b0, {(N-1){1'b0}}};
    end

    // Output assigned as unsigned to match port type
    assign c = signed_c[N-1:0];

endmodule


// Simple testbench for fixed_point_subtractor
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

    // Function to convert fixed-point number to real (for display)
    function real to_real(input [N-1:0] val);
        reg signed [N-1:0] sval;
    begin
        sval = $signed(val);
        to_real = sval / (2.0 ** Q);
    end
    endfunction

    initial begin
        $display("Time | a (real)  | b (real)  | c (real)   | Expected c");
        $display("-----------------------------------------------------------");

        // Test 1: 1.5 - 0.5 = 1.0
        a = 16'd384;   // 1.5 * 256 = 384
        b = 16'd128;   // 0.5 * 256 = 128
        #5;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 1.5-0.5);

        // Test 2: -2.25 - 1.25 = -3.5
        a = -16'sd576; // -2.25 * 256 = -576
        b = 16'd320;   // 1.25 * 256 = 320
        #5;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), -2.25-1.25);

        // Test 3: 0.75 - (-0.75) = 1.5
        a = 16'd192;   // 0.75 * 256 = 192
        b = -16'sd192; // -0.75 * 256 = -192
        #5;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.75-(-0.75));

        // Test 4: -1.0 - (-1.0) = 0.0
        a = -16'sd256; // -1.0 * 256
        b = -16'sd256; // -1.0 * 256
        #5;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // Test 5: 0.0 - 0.0 = 0.0
        a = 16'd0;
        b = 16'd0;
        #5;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // Test 6: Max positive - Max negative (test saturation not implemented)
        a = 16'sd32767;  // Max positive for 16-bit signed
        b = -16'sd32768; // Max negative for 16-bit signed
        #5;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), (32767/(2.0**Q))-(-32768/(2.0**Q)));

        $finish;
    end

endmodule