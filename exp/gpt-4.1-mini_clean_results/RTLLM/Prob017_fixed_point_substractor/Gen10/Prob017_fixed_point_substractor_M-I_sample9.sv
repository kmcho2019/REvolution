`timescale 1ns / 1ps

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
            // Same sign: perform magnitude subtraction (absolute difference)
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
                // a positive, b negative -> result sign positive if a_abs >= b_abs else negative
                sign_res = (a_abs >= b_abs) ? 1'b0 : 1'b1;
            end else if (a_sign && !b_sign) begin
                // a negative, b positive -> result sign negative if a_abs >= b_abs else positive
                sign_res = (a_abs >= b_abs) ? 1'b1 : 1'b0;
            end else begin
                // Defensive fallback: zero sign
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
            c = -$signed(mag_res);
        end else begin
            // Positive: direct magnitude
            c = $signed(mag_res);
        end
    end

endmodule



// Testbench to verify behavior with correct fixed-point conversion
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

    // Convert real number to fixed-point signed integer (rounding toward zero)
    function signed [N-1:0] real_to_fixed(input real val);
        real scaled;
        begin
            scaled = val * (2.0 ** Q);
            // Clamp to representable range of signed N-bit number
            if (scaled > (2.0**(N-1)-1)) begin
                real_to_fixed = (2**(N-1)) - 1;
            end else if (scaled < -(2.0**(N-1))) begin
                real_to_fixed = -(2**(N-1));
            end else begin
                real_to_fixed = $rtoi(scaled);
            end
        end
    endfunction

    // Convert fixed-point signed integer to real
    function real fixed_to_real(input signed [N-1:0] val);
        begin
            fixed_to_real = val / (2.0 ** Q);
        end
    endfunction

    initial begin
        $display("Time |       a       |       b       |       c       | Expected");
        $display("-----------------------------------------------------------------");

        // Test case 1: 1.5 - 0.5 = 1.0
        a = real_to_fixed(1.5);
        b = real_to_fixed(0.5);
        #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 1.5 - 0.5);

        // Test case 2: -2.25 - 1.25 = -3.5
        a = real_to_fixed(-2.25);
        b = real_to_fixed(1.25);
        #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -2.25 - 1.25);

        // Test case 3: 0.75 - (-0.75) = 1.5
        a = real_to_fixed(0.75);
        b = real_to_fixed(-0.75);
        #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.75 - (-0.75));

        // Test case 4: -1.0 - (-1.0) = 0.0 (check zero sign bit)
        a = real_to_fixed(-1.0);
        b = real_to_fixed(-1.0);
        #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        // Test case 5: 0.0 - 0.0 = 0.0 (zero case)
        a = real_to_fixed(0.0);
        b = real_to_fixed(0.0);
        #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        // Test case 6: Max positive - max negative
        a = (2**(N-1)) - 1;       // max positive integer in N-bit signed
        b = - (2**(N-1));         // max negative integer in N-bit signed (2's complement min)
        #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), fixed_to_real(a) - fixed_to_real(b));

        $finish;
    end

endmodule