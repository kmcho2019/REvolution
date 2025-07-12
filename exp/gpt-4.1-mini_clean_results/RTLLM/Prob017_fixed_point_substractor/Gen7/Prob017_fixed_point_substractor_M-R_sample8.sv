`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,      // Total bits including sign bit
    parameter integer Q = 8        // Fractional bits (for reference)
)(
    input  wire [N-1:0] a,         // Input operand a (two's complement fixed-point)
    input  wire [N-1:0] b,         // Input operand b (two's complement fixed-point)
    output wire [N-1:0] c          // Output result c (two's complement fixed-point)
);

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Function to compute absolute magnitude (N-1 bits) of two's complement input
    function [N-2:0] abs_val;
        input [N-1:0] val;
        reg [N-1:0] temp;
    begin
        temp = val[N-1] ? (~val + 1'b1) : val;
        abs_val = temp[N-2:0];
    end
    endfunction

    // Get magnitudes (absolute values) of a and b
    wire [N-2:0] mag_a = abs_val(a);
    wire [N-2:0] mag_b = abs_val(b);

    // Intermediate signals for magnitude result and sign
    wire same_sign = (sign_a == sign_b);

    // Magnitude result and result sign wires
    wire [N-2:0] mag_sub = (mag_a >= mag_b) ? (mag_a - mag_b) : (mag_b - mag_a);
    // When signs are same, result sign is inputs' sign
    wire res_sign_same = sign_a;

    // When signs differ, result magnitude = mag_a + mag_b
    wire [N-2:0] mag_add = mag_a + mag_b;

    // Determine magnitude result based on sign conditions
    wire [N-2:0] mag_res = same_sign ? mag_sub : mag_add;

    // Determine sign of result when different signs
    wire res_sign_diff = (mag_a > mag_b) ? sign_a :
                        (mag_b > mag_a) ? sign_b : 1'b0; // zero sign if magnitudes equal

    // Choose result sign based on sign relation
    wire res_sign_prezero = same_sign ? res_sign_same : res_sign_diff;

    // Force sign to 0 if magnitude is zero (handle zero result)
    wire mag_res_zero = (mag_res == {N-1{1'b0}});
    wire res_sign = mag_res_zero ? 1'b0 : res_sign_prezero;

    // Convert sign + magnitude back to two's complement
    function [N-1:0] to_twos_complement;
        input s;
        input [N-2:0] m;
        reg [N-1:0] tmp;
    begin
        if (s == 1'b0) begin
            to_twos_complement = {1'b0, m};
        end else begin
            tmp = {1'b0, m};
            to_twos_complement = (~tmp) + 1'b1;
        end
    end
    endfunction

    // Final two's complement result output
    wire [N-1:0] res_twos_comp = to_twos_complement(res_sign, mag_res);

    // Assign output
    assign c = res_twos_comp;

endmodule


// Testbench for fixed_point_subtractor (same as before for validation)
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