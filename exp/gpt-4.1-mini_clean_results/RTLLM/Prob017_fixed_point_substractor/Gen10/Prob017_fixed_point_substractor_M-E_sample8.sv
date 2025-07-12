`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,    // Total bits including sign bit
    parameter integer Q = 8      // Fractional bits
)(
    input  wire [N-1:0] a,       // Input operand a (two's complement fixed-point)
    input  wire [N-1:0] b,       // Input operand b (two's complement fixed-point)
    output reg  [N-1:0] c        // Output result c (two's complement fixed-point)
);

    // Internal register for result
    reg [N-1:0] res;

    // Internal variables for sign and magnitude extraction
    reg sign_a;
    reg sign_b;
    reg [N-2:0] mag_a;
    reg [N-2:0] mag_b;

    // Variables for result sign and magnitude
    reg res_sign;
    reg [N-2:0] res_mag;

    // Temporary signed variables for magnitude difference
    reg signed [N-1:0] diff_mag_signed;
    reg [N-1:0] sum_mag;

    // Combinational logic
    always @* begin
        // Extract signs
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Compute magnitudes as absolute values:
        // If negative: invert and add 1 (two's complement)
        if (sign_a)
            mag_a = (~a[N-2:0]) + 1'b1;
        else
            mag_a = a[N-2:0];

        if (sign_b)
            mag_b = (~b[N-2:0]) + 1'b1;
        else
            mag_b = b[N-2:0];

        if (sign_a == sign_b) begin
            // Same sign subtraction of magnitudes
            // Compute difference with signed extended magnitude
            diff_mag_signed = {1'b0, mag_a} - {1'b0, mag_b};

            if (diff_mag_signed >= 0) begin
                res_mag = diff_mag_signed[N-2:0];
                res_sign = sign_a;
            end else begin
                // mag_b > mag_a, flip sign and use positive magnitude
                res_mag = -diff_mag_signed[N-2:0];
                res_sign = sign_a; // Per problem statement, sign same as inputs
            end
        end else begin
            // Different sign => add magnitudes
            sum_mag = mag_a + mag_b;

            // Determine sign by comparing magnitudes
            if (mag_a >= mag_b)
                res_sign = sign_a;
            else
                res_sign = sign_b;

            res_mag = sum_mag[N-2:0]; // Ignore overflow (which means wrap-around, rare in magnitude sum)
        end

        // Handle zero result magnitude: force sign bit = 0
        if (res_mag == { (N-1){1'b0} }) begin
            res_sign = 1'b0;
        end

        // Construct two's complement output from sign and magnitude:
        // If positive: sign bit=0, output = magnitude bits
        // If negative: output = two's complement of magnitude

        if (res_sign == 1'b0) begin
            // Positive result
            res = {1'b0, res_mag};
        end else begin
            // Negative result: two's complement of positive magnitude
            res = (~{1'b0, res_mag}) + 1'b1;
        end
    end

    // Assign output
    always @* begin
        c = res;
    end

endmodule


// Testbench to verify fixed_point_subtractor
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

        // Test cases:
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