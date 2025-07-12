module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total bits including sign
)(
    input  wire [N-1:0] a,            // First N-bit fixed-point operand (two's complement)
    input  wire [N-1:0] b,            // Second N-bit fixed-point operand (two's complement)
    output reg  [N-1:0] c             // N-bit fixed-point addition result
);

    // Internal registers for sign, absolute values, and result
    reg a_sign, b_sign;
    reg [N-1:0] a_abs, b_abs;
    reg [N-1:0] res;
    reg res_sign;
    reg [N-1:0] abs_diff, abs_sum;

    // Function to compute absolute value of two's complement input
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val) + 1'b1;
            else
                abs_val = val;
        end
    endfunction

    always @* begin
        a_sign = a[N-1];
        b_sign = b[N-1];

        // Compute absolute values
        a_abs = abs_val(a);
        b_abs = abs_val(b);

        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            abs_sum = a_abs + b_abs;

            // Check overflow beyond N-1 bits and saturate if needed
            // Here, we wrap around naturally due to fixed width.
            // Saturation can be added if required.

            res_sign = a_sign;
            // Apply sign to sum: if sign == 1, negate abs_sum
            if (res_sign == 1'b1)
                res = (~abs_sum) + 1'b1;
            else
                res = abs_sum;
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (a_abs >= b_abs) begin
                abs_diff = a_abs - b_abs;
                res_sign = a_sign;
            end else begin
                abs_diff = b_abs - a_abs;
                res_sign = b_sign;
            end

            if (abs_diff == 0) begin
                // Result zero: sign bit 0 (positive zero)
                res_sign = 1'b0;
                res = {N{1'b0}};
            end else if (res_sign == 1'b1) begin
                res = (~abs_diff) + 1'b1;
            end else begin
                res = abs_diff;
            end
        end

        c = res;
    end

endmodule