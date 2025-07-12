module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total number of bits including sign
)(
    input  wire [N-1:0] a,            // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,            // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Compute absolute values as unsigned (to compare magnitudes)
    wire [N-1:0] a_abs = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = sign_b ? (~b + 1'b1) : b;

    // Comparison of magnitudes
    wire a_ge_b = (a_abs >= b_abs);

    // Intermediate signals for addition and subtraction results
    wire [N-1:0] sum_unsigned;
    wire [N-1:0] diff_unsigned;

    // Compute sum and difference of absolute values as unsigned (no overflow detection needed)
    assign sum_unsigned = a_abs + b_abs;
    assign diff_unsigned = a_ge_b ? (a_abs - b_abs) : (b_abs - a_abs);

    // Compute sign for subtraction result based on which operand is greater in magnitude and their signs
    // For addition when signs are equal, the sign is the same as a and b
    // For subtraction when signs differ, sign is sign of the operand with the greater magnitude
    wire res_sign_sub = a_ge_b ? sign_a : sign_b;

    // Convert magnitude + sign back to two's complement
    function [N-1:0] signed_from_mag_sign;
        input [N-1:0] magnitude;
        input sign;
        begin
            if (sign)
                signed_from_mag_sign = (~magnitude + 1'b1); // negative number
            else
                signed_from_mag_sign = magnitude;           // positive number
        end
    endfunction

    always @* begin
        if (sign_a == sign_b) begin
            // Same sign: add magnitudes and keep sign
            // Note: sum might overflow beyond N bits, but result is truncated naturally
            // For overflow beyond N bits, truncation occurs per spec
            c = signed_from_mag_sign(sum_unsigned, sign_a);
        end else begin
            // Different signs: subtract smaller magnitude from larger, sign = sign of operand with larger magnitude
            c = signed_from_mag_sign(diff_unsigned, res_sign_sub);
        end

        // Force positive zero if result is zero (all bits zero)
        if (c == {N{1'b0}}) begin
            c = {N{1'b0}};  // positive zero
        end
    end

endmodule