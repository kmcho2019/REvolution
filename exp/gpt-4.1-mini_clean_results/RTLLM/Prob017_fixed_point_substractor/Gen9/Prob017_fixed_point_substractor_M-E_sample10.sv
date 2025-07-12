`timescale 1ns/1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign)
    parameter integer Q = 8    // Fractional bits
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c
);

    // Internal signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values as unsigned [N-1:0]
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Internal magnitude result and sign
    reg [N-1:0] mag_res;
    reg        sign_res;

    always @(*) begin
        // Default outputs
        mag_res = {N{1'b0}};
        sign_res = 1'b0;

        if (a_sign == b_sign) begin
            // Same sign: perform magnitude subtraction
            if (a_abs >= b_abs) begin
                mag_res = a_abs - b_abs;
                sign_res = a_sign;  // same sign as inputs
            end else begin
                mag_res = b_abs - a_abs;
                sign_res = a_sign;  // same sign as inputs
            end
        end else begin
            // Different sign: magnitude addition
            mag_res = a_abs + b_abs;
            // Determine sign according to which magnitude is bigger in a or b for positive/negative a
            if (!a_sign && b_sign) begin
                // a positive, b negative -> result sign positive if a_abs > b_abs else negative
                sign_res = (a_abs >= b_abs) ? 1'b0 : 1'b1;
            end else if (a_sign && !b_sign) begin
                // a negative, b positive -> result sign negative if a_abs > b_abs else positive
                sign_res = (a_abs >= b_abs) ? 1'b1 : 1'b0;
            end else begin
                // Should not happen, just zero sign
                sign_res = 1'b0;
            end
        end

        // If magnitude result is zero, clear sign bit explicitly
        if (mag_res == 0) begin
            sign_res = 1'b0;
        end
    end

    // Combine sign and magnitude back to two's complement signed output
    always @(*) begin
        if (sign_res) begin
            // Negative: two's complement of magnitude
            c = -mag_res;
        end else begin
            // Positive: direct magnitude
            c = mag_res;
        end
    end

endmodule


// Testbench to verify behavior
module tb_fixed_point_subtractor;

    parameter integer N = 16;
    parameter integer Q = 8;

    reg  signed [N-1:0] a, b;
    wire signed [N-1:0] c;

    fixed_point_subtractor #(.N(N), .Q(Q)) uut(
        .a(a),
        .b(b),
        .c(c)
    );

    function real to_real(input signed [N-1:0] val);
    begin
        to_real = val / (2.0 ** Q);
    end
    endfunction

    initial begin
        $display("Time | a (real)  | b (real)  | c (real)   | Expected");
        $display("----------------------------------------------------------");

        // 1.5 - 0.5 = 1.0
        a = 16'sd(1.5 * (1<<Q));
        b = 16'sd(0.5 * (1<<Q));
        #5 $display("%4t | %10f | %10f | %10f | %10f", $time, to_real(a), to_real(b), to_real(c), 1.5-0.5);

        // -2.25 - 1.25 = -3.5
        a = -16'sd(2.25 * (1<<Q));
        b = 16'sd(1.25 * (1<<Q));
        #5 $display("%4t | %10f | %10f | %10f | %10f", $time, to_real(a), to_real(b), to_real(c), -2.25-1.25);

        // 0.75 - (-0.75) = 1.5
        a = 16'sd(0.75 * (1<<Q));
        b = -16'sd(0.75 * (1<<Q));
        #5 $display("%4t | %10f | %10f | %10f | %10f", $time, to_real(a), to_real(b), to_real(c), 0.75-(-0.75));

        // -1.0 - (-1.0) = 0.0 (check zero sign bit)
        a = -16'sd(1.0 * (1<<Q));
        b = -16'sd(1.0 * (1<<Q));
        #5 $display("%4t | %10f | %10f | %10f | %10f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // 0.0 - 0.0 = 0.0 (zero case)
        a = 16'sd(0);
        b = 16'sd(0);
        #5 $display("%4t | %10f | %10f | %10f | %10f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // Max positive - max negative
        a = 16'sd((1 << (N-1)) - 1);  // max positive
        b = -16'sd(1 << (N-1));       // max negative (2's complement min)
        #5 $display("%4t | %10f | %10f | %10f | %10f", $time, to_real(a), to_real(b), to_real(c), to_real(a) - to_real(b));

        $finish;
    end

endmodule