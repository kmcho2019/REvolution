module fixed_point_adder #(
    parameter integer Q = 8,         // Number of fractional bits
    parameter integer N = 16         // Total bits (including sign and fractional)
)(
    input  wire [N-1:0] a,           // Fixed-point operand a (two's complement)
    input  wire [N-1:0] b,           // Fixed-point operand b (two's complement)
    output reg  [N-1:0] c            // Fixed-point addition result (two's complement)
);

    // Internal registers for sign and magnitude
    reg sign_a, sign_b;
    reg [N-1:0] abs_a, abs_b;

    // Internal variables for addition/subtraction results
    reg [N:0] sum_abs;        // One extra bit for carry
    reg [N-1:0] diff_abs;     // Result of subtraction of magnitudes
    reg sign_res;
    reg [N-1:0] magnitude_res;

    // Function: Compute absolute value of two's complement number
    function [N-1:0] abs_val(input [N-1:0] in);
        begin
            if (in[N-1] == 1'b1)
                abs_val = (~in) + 1'b1;  // two's complement negation
            else
                abs_val = in;
        end
    endfunction

    // Compare absolute values: returns 1 if abs_a >= abs_b else 0
    function cmp_abs_ge(input [N-1:0] x, input [N-1:0] y);
        begin
            // Simple unsigned comparison since inputs are absolute values
            if (x >= y)
                cmp_abs_ge = 1'b1;
            else
                cmp_abs_ge = 1'b0;
        end
    endfunction

    always @* begin
        sign_a = a[N-1];
        sign_b = b[N-1];

        abs_a = abs_val(a);
        abs_b = abs_val(b);

        if (sign_a == sign_b) begin
            // Same sign: add absolute values, result sign same as inputs
            sum_abs = {1'b0, abs_a} + {1'b0, abs_b};
            // If overflow in addition, truncate higher bit (wraparound)
            magnitude_res = sum_abs[N-1:0];
            sign_res = sign_a;
        end else begin
            // Different signs: subtract smaller absolute from larger absolute
            if (cmp_abs_ge(abs_a, abs_b)) begin
                diff_abs = abs_a - abs_b;
                magnitude_res = diff_abs;
                sign_res = (diff_abs == 0) ? 1'b0 : sign_a;  // zero is positive
            end else begin
                diff_abs = abs_b - abs_a;
                magnitude_res = diff_abs;
                sign_res = (diff_abs == 0) ? 1'b0 : sign_b;  // zero is positive
            end
        end

        // Convert magnitude + sign back to two's complement
        if (sign_res == 1'b1)
            res = (~magnitude_res) + 1'b1;
        else
            res = magnitude_res;

        c = res;
    end

    // Internal register to hold final result before assign
    reg [N-1:0] res;

endmodule