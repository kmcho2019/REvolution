`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,      // Total bits including sign bit
    parameter integer Q = 8        // Fractional bits (for reference)
)(
    input  wire [N-1:0] a,         // Input operand a (two's complement fixed-point)
    input  wire [N-1:0] b,         // Input operand b (two's complement fixed-point)
    output reg  [N-1:0] c          // Output result c (two's complement fixed-point)
);

    // Internal signals
    reg        sign_a;             // Sign bit of a
    reg        sign_b;             // Sign bit of b
    reg [N-2:0] mag_a;             // Magnitude of a (absolute value)
    reg [N-2:0] mag_b;             // Magnitude of b (absolute value)
    reg        res_sign;           // Sign bit of the result
    reg [N-2:0] mag_res;           // Magnitude of the result (absolute value)
    reg [N-1:0] res_twos_comp;     // Result in two's complement format

    // Function to get magnitude (abs) from two's complement
    function [N-2:0] abs_val;
        input [N-1:0] val;
        reg [N-1:0] temp;
    begin
        if (val[N-1] == 1'b1)      // Negative number
            temp = (~val + 1'b1);
        else
            temp = val;
        abs_val = temp[N-2:0];
    end
    endfunction

    // Function to convert sign + magnitude to two's complement
    function [N-1:0] to_twos_complement;
        input        s;            // sign bit: 0=positive,1=negative
        input [N-2:0] m;           // magnitude
        reg [N-1:0]  tmp;
    begin
        if (s == 1'b0) begin
            // positive number, MSB=0
            to_twos_complement = {1'b0, m};
        end else begin
            // negative number, compute two's complement of magnitude
            tmp = {1'b0, m};
            to_twos_complement = (~tmp) + 1'b1;
        end
    end
    endfunction

    always @(*) begin
        // Extract signs
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Extract magnitudes
        mag_a = abs_val(a);
        mag_b = abs_val(b);

        if (sign_a == sign_b) begin
            // Same sign subtraction: result magnitude = |a| - |b|
            if (mag_a >= mag_b) begin
                mag_res = mag_a - mag_b;
                res_sign = sign_a;
            end else begin
                mag_res = mag_b - mag_a;
                res_sign = sign_a;  // sign stays same per spec (inputs have same sign)
            end
        end else begin
            // Different sign: add magnitudes
            mag_res = mag_a + mag_b;

            // Result sign depends on which operand has greater magnitude
            if (mag_a > mag_b) begin
                res_sign = sign_a;
            end else if (mag_b > mag_a) begin
                res_sign = sign_b;
            end else begin
                // magnitudes equal, result zero, sign = 0 per spec
                res_sign = 1'b0;
                mag_res = {N-1{1'b0}};
            end
        end

        // If result magnitude zero, force sign bit to zero per problem statement
        if (mag_res == {N-1{1'b0}}) begin
            res_sign = 1'b0;
        end

        // Convert sign + magnitude to two's complement
        res_twos_comp = to_twos_complement(res_sign, mag_res);

        // Assign result to output
        c = res_twos_comp;
    end

endmodule


// Testbench for fixed_point_subtractor
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