module fixed_point_subtractor #(
    parameter integer N = 16,  // total bits (including sign)
    parameter integer Q = 8    // fractional bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Sign bit extraction
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitude extraction: absolute values of inputs (without sign bit)
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Extended magnitudes for arithmetic with carry
    reg [N-1:0] a_abs_ext;
    reg [N-1:0] b_abs_ext;

    // Result magnitude and sign
    reg [N-1:0] res_mag;
    reg res_sign;

    always @* begin
        // Extend magnitude with leading zero (sign bit)
        a_abs_ext = {1'b0, a_mag};
        b_abs_ext = {1'b0, b_mag};

        if (a_sign == b_sign) begin
            // Same signs: result = a_mag - b_mag, sign = a_sign
            if (a_abs_ext >= b_abs_ext) begin
                res_mag  = a_abs_ext - b_abs_ext;
                res_sign = a_sign;
            end else begin
                res_mag  = b_abs_ext - a_abs_ext;
                res_sign = b_sign; // same as a_sign, equal here
            end
        end else begin
            // Different signs: result = a_mag + b_mag
            res_mag  = a_abs_ext + b_abs_ext;
            // Sign depends on operand with larger magnitude
            if (a_abs_ext > b_abs_ext)
                res_sign = a_sign;
            else if (b_abs_ext > a_abs_ext)
                res_sign = b_sign;
            else
                // Magnitudes equal: result zero
                res_sign = 1'b0;
        end

        // Convert magnitude back to signed fixed-point number
        if (res_mag == 0) begin
            // zero result: sign bit cleared explicitly
            c = {1'b0, {(N-1){1'b0}}};
        end else begin
            if (res_sign) begin
                // Negative: two's complement
                c = {res_sign, (~res_mag[N-2:0] + 1'b1)};
            end else begin
                // Positive: direct magnitude
                c = {res_sign, res_mag[N-2:0]};
            end
        end
    end

endmodule


// Simple testbench to demonstrate fixed_point_subtractor behavior
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

    // Convert fixed-point to real number for easier checking
    function real to_real;
        input [N-1:0] val;
        reg signed [N-1:0] sval;
        begin
            sval = val;
            to_real = sval / (2.0**Q);
        end
    endfunction

    initial begin
        $display("Time |          a            |          b            |          c            | a-b (real)");
        $display("--------------------------------------------------------------------------------------------------");

        // Helper to build fixed-point representation from real input
        function [N-1:0] to_fixed;
            input real r;
            reg signed [N-1:0] temp;
            begin
                temp = $rtoi(r * (2.0**Q));
                to_fixed = temp;
            end
        endfunction

        // Test cases:
        a = to_fixed(  3.25); b = to_fixed( 1.75); #1;
        $display("%4t | %0d (%.6f) | %0d (%.6f) | %0d (%.6f) | %.6f",
                 $time, a, to_real(a), b, to_real(b), c, to_real(c), to_real(c));

        a = to_fixed( -2.50); b = to_fixed( 0.75); #1;
        $display("%4t | %0d (%.6f) | %0d (%.6f) | %0d (%.6f) | %.6f",
                 $time, a, to_real(a), b, to_real(b), c, to_real(c), to_real(c));

        a = to_fixed(  1.25); b = to_fixed(-1.25); #1;
        $display("%4t | %0d (%.6f) | %0d (%.6f) | %0d (%.6f) | %.6f",
                 $time, a, to_real(a), b, to_real(b), c, to_real(c), to_real(c));

        a = to_fixed( -1.00); b = to_fixed(-1.00); #1;
        $display("%4t | %0d (%.6f) | %0d (%.6f) | %0d (%.6f) | %.6f",
                 $time, a, to_real(a), b, to_real(b), c, to_real(c), to_real(c));

        a = to_fixed( 0.00); b = to_fixed( 0.00); #1;
        $display("%4t | %0d (%.6f) | %0d (%.6f) | %0d (%.6f) | %.6f",
                 $time, a, to_real(a), b, to_real(b), c, to_real(c), to_real(c));

        a = to_fixed( 0.50); b = to_fixed( 0.75); #1;
        $display("%4t | %0d (%.6f) | %0d (%.6f) | %0d (%.6f) | %.6f",
                 $time, a, to_real(a), b, to_real(b), c, to_real(c), to_real(c));

        $finish;
    end

endmodule